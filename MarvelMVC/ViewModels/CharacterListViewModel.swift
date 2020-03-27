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

    init(characters: [Character] = [Character](),
         dataService: CharacterDataServiceProtocol = CharacterDataService(),
         imageDataService: CharacterImageDataServiceProtocolV2 = CharacterImageDataServiceV2()) {

        self.characters = characters
        self.dataService = dataService
        self.imageDataService = imageDataService
        self.dataService.delegate = self
    }

    func getCharacters() {
        dataService.fetchCharacters()
    }

    func getImage(for character: Character, onSuccess: ((UIImage?) -> Void)?, onFailure: ((Error) -> Void)?) {
        //TODO: Change to 'If image not present in Cache' logic
        if character.image == nil {
            guard let index = characters.firstIndex(of: character) else { return }
            imageDataService.fetchImage(for: character, onSuccess: { image in
                self.characters[index].image = image
                onSuccess?(image)
            }) { error in
                onFailure?(error)
            }
        } else {
            onSuccess?(character.image)
        }
    }

    func didFetchCharacters(characters: [Character]?, error: Error?) {
        self.characters = characters ?? []
        delegate?.didUpdateCharacters()
    }
}
