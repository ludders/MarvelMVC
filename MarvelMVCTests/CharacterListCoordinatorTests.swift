//
//  CharacterListCoordinatorTests.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 12/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import XCTest
@testable import MarvelMVC

class CharacterListCoordinatorTests: XCTestCase {

    var subject: CharacterListCoordinator!
    var navigationController = UINavigationController()
    let mockViewModel = MockCharacterListViewModel()

    override func setUp() {
        subject = CharacterListCoordinator(navigationController: navigationController, viewModel: mockViewModel)
    }

    func testStartPushesCharacterListViewController() {
        subject.start()
        XCTAssert(subject.navigationController.topViewController is CharacterListViewController)
    }

    func testshowCharacterDetailsPushesDetailViewController() {
        let mockCharacter = Character()
        subject.showCharacterDetails(character: mockCharacter)
        guard let viewController = subject.navigationController.topViewController as? DetailViewController else {
            XCTFail("Expected topViewController to be of type \(DetailViewController.self)")
            return
        }
        XCTAssert(viewController.character == mockCharacter)
    }
}
