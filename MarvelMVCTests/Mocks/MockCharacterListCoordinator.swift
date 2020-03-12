//
//  MockCharacterListCoordinator.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 11/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit
@testable import MarvelMVC

class MockCharacterListCoordinator: CharacterListCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = UINavigationController()
    var startCalled: Bool = false
    var showCharacterDetailsCalled: Bool = false
    var characterPassed: Character?

    func start() {
        startCalled = true
    }

    func showCharacterDetails(character: Character) {
        showCharacterDetailsCalled = true
        characterPassed = character
    }
}
