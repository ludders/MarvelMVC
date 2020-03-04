//
//  CharacterModel.swift
//  MarvelMVC
//
//  Created by dludlow7 on 26/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

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

final class NetworkErrors: NSError {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func unexpectedResponseType() -> NSError {
        return NSError(domain: "",
                       code: 0,
                       userInfo: ["localizedDescription": "Unexpected response type recieved"])
    }

    static func httpStatusError(statusCode: Int) -> NSError {
        return NSError(domain: "",
                       code: statusCode,
                       userInfo: ["localizedDescription": "HTTP Status Error \(statusCode)"])
    }

    static func unexpectedMIMEType(mimeType: String) -> NSError {
        return NSError(domain: "",
                       code: 0,
                       userInfo: ["localizedDescription": "Unexpected response MIME type: \(mimeType)"])
    }

    static func dataDecodeError() -> NSError {
        return NSError(domain: "",
                       code: 0,
                       userInfo: ["localizedDescription": "Failed to decode response data"])
    }
}
