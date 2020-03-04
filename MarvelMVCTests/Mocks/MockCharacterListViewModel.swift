//
//  MockCharacterListViewModel.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 05/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
@testable import MarvelMVC

class MockCharacterListViewModel: CharacterListViewModelProtocol {
    var characters: [Character]
    var dataService: CharacterDataServiceProtocol
    var imageDataService: CharacterImageDataServiceProtocolV2

    public init(characters: [Character] = [],
                dataService: CharacterDataServiceProtocol = MockCharacterDataService(),
                imageDataService: CharacterImageDataServiceProtocolV2 = MockCharacterImageDataService()) {
        self.characters = characters
        self.dataService = dataService
        self.imageDataService = imageDataService
    }
}
