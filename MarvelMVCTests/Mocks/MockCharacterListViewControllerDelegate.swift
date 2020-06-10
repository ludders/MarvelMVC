//
//  MockCharacterListViewControllerDelegate.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 10/06/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
@testable import MarvelMVC

class MockCharacterListViewControllerDelegate: CharacterListViewControllerDelegate {

    var showCharacterDetailsCalled: Bool = false
    var characterPassed: Character? = nil
    var urlPassed: URL? = nil

    func didTapCharacter(character: Character) {
        showCharacterDetailsCalled = true
        characterPassed = character
    }

    func didTapWebsite(url: URL) {
        urlPassed = url
    }
}
