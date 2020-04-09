//
//  CharacterListViewModel.swift
//  MarvelMVC
//
//  Created by dludlow7 on 03/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterListViewModelDelegate {
    func didUpdateCharacters()
}

protocol CharacterListViewModelProtocol {
    var characters: [Character] { get }
    var delegate: CharacterListViewModelDelegate? { get set }
    var dataService: CharacterDataServiceProtocol { get }
    var imageDataService: CharacterImageDataServiceProtocolV2 { get }

    func getCharacters()
    func getImage(for character: Character, onSuccess: ((UIImage?) -> Void)?, onFailure: ((Error) -> Void)?)
}

class CharacterListViewModel: CharacterListViewModelProtocol, CharacterDataServiceDelegate {
    var characters: [Character]
    var delegate: CharacterListViewModelDelegate?
    var dataService: CharacterDataServiceProtocol
    var imageDataService: CharacterImageDataServiceProtocolV2
    var imageCache: NSCache<NSString, UIImage>

    init(characters: [Character] = [Character](),
         dataService: CharacterDataServiceProtocol = CharacterDataService(),
         imageDataService: CharacterImageDataServiceProtocolV2 = CharacterImageDataServiceV2(),
         imageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()) {

        self.characters = characters
        self.dataService = dataService
        self.imageDataService = imageDataService
        self.imageCache = imageCache

        self.dataService.delegate = self
    }

    func getCharacters() {
        dataService.fetchCharacters()
    }

    func getImage(for character: Character, onSuccess: ((UIImage?) -> Void)?, onFailure: ((Error) -> Void)?) {

        guard let index = characters.firstIndex(of: character) else { return }
        guard let imageURL = character.imageURL else {
            onSuccess?(nil)
            return
        }

        //Images cached per-URL, not per-character
        if let cachedImageForURL = imageCache.object(forKey: imageURL as NSString){
            if character.image == nil {
                self.characters[index].image = cachedImageForURL
            }
            onSuccess?(cachedImageForURL)
        } else {
            imageDataService.fetchImage(for: character, onSuccess: { image in
                guard let image = image else {
                    onSuccess?(nil)
                    return
                }
                self.characters[index].image = image
                self.imageCache.setObject(image, forKey: imageURL as NSString)
                onSuccess?(image)
            }) { error in
                onFailure?(error)
            }
        }
    }

    func didFetchCharacters(characters: [Character]?, error: Error?) {
        self.characters = characters ?? []
        delegate?.didUpdateCharacters()
    }
}
