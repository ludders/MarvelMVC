//
//  CharacterListViewControllerTests.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 05/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import XCTest

@testable import MarvelMVC

class CharacterListViewControllerTests: XCTestCase {

    var subject: CharacterListViewController!
    var mockViewModel: MockCharacterListViewModel!
    var mockCharacterImageDataService: MockCharacterImageDataService!
    var mockCoordinator: MockCharacterListCoordinator!
    var mockDispatcher: MockDispatcher!
    var mockUITableView = MockUITableView()
    var testImage = UIImage(named: "blank")
    var testImage2 = UIImage(named: "characterDefault")
    

    override func setUp() {
        mockCharacterImageDataService = MockCharacterImageDataService()
        mockViewModel = MockCharacterListViewModel(imageDataService: mockCharacterImageDataService)
        mockCoordinator = MockCharacterListCoordinator()
        mockDispatcher = MockDispatcher()
        subject = CharacterListViewController(characterListViewModel: mockViewModel,
                                              coordinator: mockCoordinator,
                                              mainDispatcher: mockDispatcher)
    }

    func testInitWithCoder_ReturnsNil() {
        XCTAssertNil(CharacterListViewController(coder: NSCoder()))
    }

    func testRowHeight_IsExpectedValue() {
        let expectedHeight = CGFloat(150)
        let actualHeight = subject.tableView(subject.tableView, heightForRowAt: IndexPath())

        XCTAssertEqual(expectedHeight, actualHeight)
    }

    func testCellForRowAt_WithExistingImage_ConfiguresAndReturnsACharacterTableViewCell() {
        let mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: testImage)
        let mockCharacter2 = Character(name: "Test2", description: "Description2", imageURL: "www.blah.com/test2.jpg", image: testImage2)
        mockViewModel.characters = [mockCharacter, mockCharacter2]
        subject.tableView.reloadData()

        let indexPath = IndexPath(row: 1, section: 0)
        guard let cell = subject.tableView(subject.tableView, cellForRowAt: indexPath) as? CharacterTableViewCell else {
            XCTFail("cellForRowAt should return an object of type CharacterTableViewCell")
            return
        }

        let actualImage = cell.characterImageView.image

        XCTAssertEqual(testImage2, actualImage)
        XCTAssertEqual("Test2", cell.textView.text)
    }

    func testCellForRowAt_WithNoImage_ConfiguresAndReturnsACharacterTableViewCellAndUpdatesRowWithImage() {
        let mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: nil)
        mockViewModel.characters = [mockCharacter]
        mockCharacterImageDataService.fetchImageBehaviour = .shouldSucceedWithImage(testImage!)
        subject.tableView.reloadData()

        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = subject.tableView(subject.tableView, cellForRowAt: indexPath) as? CharacterTableViewCell else {
            XCTFail("cellForRowAt should return an object of type CharacterTableViewCell")
            return
        }
        XCTWaiter.wait(for: [mockCharacterImageDataService.fetchImageExpectation], timeout: 1)

        let actualImage = cell.characterImageView.image
        XCTAssertEqual(testImage, actualImage)
    }

    func testDidSelectRowAt_StartsCharacterListCoordinator() {
        let mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: nil)
        let mockCharacter2 = Character(name: "Test2", description: "Description2", imageURL: "www.blah.com/test2.jpg", image: nil)

        mockViewModel.characters = [mockCharacter, mockCharacter2]
        subject.coordinator = mockCoordinator

        let indexPath = IndexPath(row: 1, section: 0)
        subject.tableView(subject.tableView, didSelectRowAt: indexPath)
        XCTAssertTrue(mockCoordinator.showCharacterDetailsCalled)
        XCTAssertEqual(mockCoordinator.characterPassed, mockCharacter2)
    }

    func testDidUpdateCharacters_ReloadsTableView() {
        subject.tableView = mockUITableView
        subject.didUpdateCharacters()
        XCTAssertTrue(mockUITableView.reloadDataCalled)
    }
}
