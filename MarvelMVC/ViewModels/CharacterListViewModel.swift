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
    var dataController: CharacterDataControllable { get set }
    var imageDataController: CharacterImageDataControllable { get set }
}

class CharacterListViewModel: CharacterListViewModelProtocol {

    var characters: [Character]
    var dataController: CharacterDataControllable
    var imageDataController: CharacterImageDataControllable

    init(characters: [Character] = [Character](),
         dataController: CharacterDataControllable = CharacterDataController(),
         imageDataController: CharacterImageDataControllable = CharacterImageDataController()) {

        self.characters = characters
        self.dataController = dataController
        self.imageDataController = imageDataController
    }
}
