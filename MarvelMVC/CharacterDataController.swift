//
//  CharacterModel.swift
//  MarvelMVC
//
//  Created by dludlow7 on 26/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterDataControllable {
    var characters: [Character] { get set }
    var delegate: CharacterDataControllerDelegate? { get set }
    func fetchCharacters()
}

protocol CharacterDataControllerDelegate {
    func didFetchCharacters(characters: [Character])
}

class CharacterDataController: NSObject, CharacterDataControllable {
    var characters = [Character]()
    var delegate: CharacterDataControllerDelegate?

    func fetchCharacters() {
        let url = URL(string: "https://gateway.marvel.com/v1/public/characters?ts=1&apikey=ff3d4847092294acc724123682af904b&hash=412b0d63f1d175474216fadfcc4e4fed&limit=25&orderBy=-modified")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { jsonData, response, error in
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
                let marvelResponse = try! decoder.decode(MarvelAPIResponse.self, from: jsonData)
                if let characterData = marvelResponse.data?.characters {
                    for character in characterData {
                        self.createCharacter(for: character)
                    }
                    self.delegate?.didFetchCharacters(characters: self.characters)
                }
            }
        }
        task.resume()
    }

    private func createCharacter(for result: CharacterData) {
        var imageURL: String? = nil
        if let thumbnail = result.thumbnail {
            imageURL = thumbnail.path + "." + thumbnail.thumbnailExtension
        }
        let character = Character(name: result.name, description: result.description, imageURL: imageURL, image: nil)
        self.characters.append(character)
    }

}
