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
    var dataService: CharacterDataServiceProtocol { get set }
    var imageDataService: CharacterImageDataServiceProtocolV2 { get set }
}

class CharacterListViewModel: CharacterListViewModelProtocol {

    var characters: [Character]
    var dataService: CharacterDataServiceProtocol
    var imageDataService: CharacterImageDataServiceProtocolV2

    init(characters: [Character] = [Character](),
         dataController: CharacterDataServiceProtocol = CharacterDataService(),
         imageDataController: CharacterImageDataServiceProtocolV2 = CharacterImageDataServiceV2()) {

        self.characters = characters
        self.dataService = dataController
        self.imageDataService = imageDataController
    }
}
