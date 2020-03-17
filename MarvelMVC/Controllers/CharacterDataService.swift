//
//  CharacterModel.swift
//  MarvelMVC
//
//  Created by dludlow7 on 26/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

/*
 This comment is about the this DataService and the ViewModel, I think you've mixed up the two a little.
 This class is a Data Service, really it should just fetch the characters, but it also stores the characters
 Your view model literally just wraps the data service. I.e. the ViewModel doesn't really do anything.
 
 Then you run into the viewcontroller reaching deeper into the dataServices to the do stuff:
 
 characterListViewModel.imageDataService.defaultImage = defaultCharacterImage
 characterListViewModel.dataService.delegate = self
 characterListViewModel.dataService.fetchCharacters()
 
 Really the view model should have a getCharacters function and it should delegate back to the viewController (or use closures).
 
 Then, the view model would call the data service. But in a more complex implementation it may also know how to call a cache, if the characters have already been fetched.
 The view model would also be responsible for holding the model, i.e. the characters. 
 
 Watch the beginnings of this video https://www.youtube.com/watch?v=vDzIeFzGAuU, it's great for an MVC to MVVM explanation. 
 */

protocol CharacterDataServiceProtocol {
    var characters: [Character] { get set }
    var delegate: CharacterDataServiceDelegate? { get set }
    func fetchCharacters()
}

protocol CharacterDataServiceDelegate {
    func didFetchCharacters(characters: [Character]?, error: Error?)
}

class CharacterDataService: NSObject, CharacterDataServiceProtocol {
    var characters = [Character]()
    var delegate: CharacterDataServiceDelegate?
    private let urlSession: URLSession

    required init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchCharacters() {
        let url = URL(string: "https://gateway.marvel.com/v1/public/characters?ts=1&apikey=ff3d4847092294acc724123682af904b&hash=412b0d63f1d175474216fadfcc4e4fed&limit=25&orderBy=-modified")!
        let request = URLRequest(url: url)
        let task = urlSession.dataTask(with: request) { jsonData, response, error in
            if let error = error {
                self.delegate?.didFetchCharacters(characters: nil, error: error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                self.delegate?.didFetchCharacters(characters: nil,
                                                  error: NetworkErrors.unexpectedResponseType())
                return
            }
            if !(200...299).contains(httpResponse.statusCode) {
                self.delegate?.didFetchCharacters(characters: self.characters,
                                                  error: NetworkErrors.httpStatusError(statusCode: httpResponse.statusCode))
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
                    self.delegate?.didFetchCharacters(characters: self.characters, error: nil)
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
