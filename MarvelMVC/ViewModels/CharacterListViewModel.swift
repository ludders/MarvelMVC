//
//  CharacterListViewModel.swift
//  MarvelMVC
//
//  Created by dludlow7 on 03/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterListViewModelProtocol {
    var characters: [Character] { get set }
    var dataController: CharacterDataServiceProtocol { get set }
    var imageDataController: CharacterImageDataServiceProtocol { get set }
}

class CharacterListViewModel: CharacterListViewModelProtocol {

    var characters: [Character]
    var dataController: CharacterDataServiceProtocol
    var imageDataController: CharacterImageDataServiceProtocol

    init(characters: [Character] = [Character](),
         dataController: CharacterDataServiceProtocol = CharacterDataService(),
         imageDataController: CharacterImageDataServiceProtocol = CharacterImageDataService()) {

        self.characters = characters
        self.dataController = dataController
        self.imageDataController = imageDataController
    }
}
