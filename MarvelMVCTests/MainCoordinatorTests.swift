//
//  CharacterListCoordinatorTests.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 12/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import SafariServices
import XCTest
@testable import MarvelMVC

class CharacterListCoordinatorTests: XCTestCase {

    var subject: MainCoordinator!
    var navigationController = UINavigationController()
    let mockCharacter = Character(name: "test",
                                  description: "testDescription",
                                  imageURL: nil,
                                  image: nil,
                                  detailURL: "testURL")

    override func setUp() {
        subject = MainCoordinator(navigationController: navigationController)
    }

    func testStartPushesCharacterListViewController() {
        subject.start()
        XCTAssert(subject.navigationController.topViewController is CharacterListViewController)
    }

    func testDelegateDidTapWebsitePushesSFSafariViewController() {
        subject.didTapWebsite(url: URL(string: "http://www.test.com")!)
        XCTAssert(subject.navigationController.topViewController is SFSafariViewController)
    }

    func testDelegateDidTapCharacterPushesDetailViewController() {
        subject.didTapCharacter(character: mockCharacter)
        let topViewController = subject.navigationController.topViewController
        guard let viewController = topViewController as? DetailViewController else {
            XCTFail("Expected \(type(of: DetailViewController.self)) got \(type(of: topViewController))")
            return
        }

        XCTAssertEqual(viewController.character, mockCharacter)
    }
}

//
//extension MainCoordinator: CharacterListViewControllerDelegate {
//    func didTapCharacter(character: Character) {
//        let viewController = DetailViewController(character: character)
//        viewController.delegate = self
//        navigationController.pushViewController(viewController, animated: true)
//    }
//
//    func didTapWebsite(url: URL) {
//        let viewController = SFSafariViewController(url: url)
//        navigationController.pushViewController(viewController, animated: true)
//    }
//}
