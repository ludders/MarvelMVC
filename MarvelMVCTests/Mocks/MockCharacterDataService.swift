//
//  MockCharacterDataService.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 05/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
@testable import MarvelMVC

class MockCharacterDataService: CharacterDataServiceProtocol {

    var characters: [Character]
    var delegate: CharacterDataServiceDelegate?
    var fetchCharactersCalled: Bool = false

    public init(characters: [Character] = [], delegate: CharacterDataServiceDelegate? = nil) {
        self.characters = characters
        self.delegate = delegate
    }

    func fetchCharacters() {
        fetchCharactersCalled = true
    }
}
