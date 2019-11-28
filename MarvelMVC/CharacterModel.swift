//
//  CharacterModel.swift
//  MarvelMVC
//
//  Created by dludlow7 on 26/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterModelDelegate {
    func didFetchCharacters(characters: [Character])
}

class CharacterModel: NSObject {

    var characters = [Character]()
    var delegate: CharacterModelDelegate?
    private var session = URLSession(configuration: .ephemeral)
    @objc var progress = Progress()

    override init() {
        super.init()
        self.addObserver(self, forKeyPath: #keyPath(progress.isFinished), options: .new, context: nil)
    }

    func fetchCharacters() {
        let url = URL(string: "https://gateway.marvel.com/v1/public/characters?ts=1&apikey=ff3d4847092294acc724123682af904b&hash=412b0d63f1d175474216fadfcc4e4fed&limit=25&orderBy=-modified")!
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { jsonData, response, error in
            if let error = error {
                print(error)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid Character API response")
                    return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                let jsonData = jsonData {

                let decoder = JSONDecoder()
                let characterResponse = try! decoder.decode(CharacterAPIResponse.self, from: jsonData)
                if let results = characterResponse.data?.results {
                    print("Characters retrieved")

                    self.progress.totalUnitCount = Int64(results.count)
                    for result in results {
                        self.createCharacter(for: result)
                    }
                }
            }
        }
        task.resume()
    }

    private func createCharacter(for result: CharacterData) {
        if let thumbnail = result.thumbnail {
            let url = URL(string: "\(thumbnail.path).\(thumbnail.thumbnailExtension)")!
            let task = session.dataTask(with: url) { imageData, response, error in
                if let error = error {
                    print(error)
                }

                let image: UIImage?

                if let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode),
                    let mimeType = httpResponse.mimeType,
                    mimeType.contains("image/"),
                    let imageData = imageData {
                    print("Image retrieved for id: \(result.id)")
                    image = UIImage(data: imageData)
                } else {
                    print("Nil Image for id: \(result.id)")
                    image = UIImage(named: "anonymous")
                }
                let character = Character(name: result.name, description: result.description, image: image)
                self.characters.append(character)
                self.progress.completedUnitCount += 1
            }
            task.resume()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "progress.finished" {
            delegate?.didFetchCharacters(characters: characters)
        }
    }
}
