//
//  MockCharacterDataControllerDelegate.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 18/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
@testable import MarvelMVC

class MockCharacterDataServiceDelegate: CharacterDataServiceDelegate {
    var characters: [Character]?
    var error: Error? = nil
    var didFetchCharactersCalled = false

    func didFetchCharacters(characters: [Character]?, error: Error?) {
        self.characters = characters
        self.error = error
        didFetchCharactersCalled = true
    }
}
