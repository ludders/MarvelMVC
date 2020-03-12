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
    var testImage = UIImage(named: "blank")
    var testImage2 = UIImage(named: "characterDefault")
    

    override func setUp() {
        mockCharacterImageDataService = MockCharacterImageDataService()
        mockViewModel = MockCharacterListViewModel(imageDataService: mockCharacterImageDataService)
        mockCoordinator = MockCharacterListCoordinator()
        subject = CharacterListViewController(characterListViewModel: mockViewModel, coordinator: mockCoordinator)
    }

    func testInitWithCoderReturnsNil() {
        XCTAssertNil(CharacterListViewController(coder: NSCoder()))
    }

    func testRowHeightIsExpectedValue() {
        let expectedHeight = CGFloat(150)
        let actualHeight = subject.tableView(subject.tableView, heightForRowAt: IndexPath())

        XCTAssertEqual(actualHeight, expectedHeight)
    }

    func testCellForRowWithExistingImageAtConfiguresAndReturnsACharacterTableViewCell() {
        let mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: testImage)
        let mockCharacter2 = Character(name: "Test2", description: "Description2", imageURL: "www.blah.com/test2.jpg", image: testImage2)
        subject.characterListViewModel.characters = [mockCharacter, mockCharacter2]
        subject.tableView.reloadData()

        let indexPath = IndexPath(row: 1, section: 0)
        guard let cell = subject.tableView(subject.tableView, cellForRowAt: indexPath) as? CharacterTableViewCell else {
            XCTFail("cellForRowAt should return an object of type CharacterTableViewCell")
            return
        }

        XCTAssert(cell.characterImageView.image == testImage2)
        XCTAssert(cell.textView.text == "Test2")
    }

    func testCellForRowAtWithNoImageConfiguresAndReturnsACharacterTableViewCellAndUpdatesRowWithImage() {
        let mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: nil)
        subject.characterListViewModel.characters = [mockCharacter]
        mockCharacterImageDataService.fetchImageBehaviour = .shouldSucceedWithImage(testImage!)
        subject.tableView.reloadData()

        let indexPath = IndexPath(row: 0, section: 0)
        guard subject.tableView(subject.tableView, cellForRowAt: indexPath) is CharacterTableViewCell else {
            XCTFail("cellForRowAt should return an object of type CharacterTableViewCell")
            return
        }

        //TODO: Get clarification on this one!
        XCTWaiter.wait(for: [mockCharacterImageDataService.fetchImageExpectation], timeout: 1)

        let actualImage = subject.characterListViewModel.characters.first?.image
        XCTAssert(actualImage == testImage)
    }

    func testFetchCharacterImageAndUpdateTableRowUpdatesCorrectCharacters() {
        let mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: nil)
        let mockCharacter2 = Character(name: "Test2", description: "Description2", imageURL: "www.blah.com/test.jpg", image: nil)
        subject.characterListViewModel.characters = [mockCharacter, mockCharacter2]

        mockCharacterImageDataService.fetchImageBehaviour = .shouldSucceedWithImage(testImage!)
        subject.fetchCharacterImageAndUpdateTableRow(character: mockCharacter, indexPathForRow: IndexPath(row: 0, section: 0))
        XCTAssert(subject.characterListViewModel.characters[0].image == testImage)

        mockCharacterImageDataService.fetchImageBehaviour = .shouldSucceedWithImage(testImage2!)
        subject.fetchCharacterImageAndUpdateTableRow(character: mockCharacter2, indexPathForRow: IndexPath(row: 1, section: 0))
        XCTAssert(subject.characterListViewModel.characters[1].image == testImage2)
    }

    func testPrefetchRowsFetchesAndUpdatesCharacterImages() {
        let mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: nil)
        let mockCharacter2 = Character(name: "Test2", description: "Description2", imageURL: "www.blah.com/test.jpg", image: nil)

        subject.characterListViewModel.characters = [mockCharacter, mockCharacter2]
        let indexPaths: [IndexPath] = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)]

        mockCharacterImageDataService.fetchImageExpectation.expectedFulfillmentCount = 2
        mockCharacterImageDataService.fetchImageBehaviour = .shouldSucceedWithImage(testImage!)
        subject.tableView(subject.tableView, prefetchRowsAt: indexPaths)

        let actualImage = subject.characterListViewModel.characters[0].image
        let actualImage2 = subject.characterListViewModel.characters[1].image

        XCTWaiter.wait(for: [mockCharacterImageDataService.fetchImageExpectation], timeout: 1)

        XCTAssert((actualImage == testImage) && (actualImage2 == testImage))
    }

    func testUpdateTableRowCallsReloadRowsWithExpectedCharacterIndexPath() {
        let mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: nil)
        let mockCharacter2 = Character(name: "Test2", description: "Description2", imageURL: "www.blah.com/test2.jpg", image: nil)
        let mockDispatcher = MockDispatcher()
        let mockTableVIew = MockUITableView()

        subject.characterListViewModel.characters = [mockCharacter, mockCharacter2]
        subject.mainDispatcher = mockDispatcher
        subject.tableView = mockTableVIew
        subject.updateTableRow(for: mockCharacter2)

        let expectedIndexPath = IndexPath(row: 1, section: 0)
        XCTAssert(mockTableVIew.reloadRowsCalled)
        XCTAssert(mockTableVIew.indexPathsUsed == [expectedIndexPath])
    }

    func testDidSelectRowAtStartsCharacterListCoordinator() {
        let mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: nil)
        let mockCharacter2 = Character(name: "Test2", description: "Description2", imageURL: "www.blah.com/test2.jpg", image: nil)

        subject.characterListViewModel.characters = [mockCharacter, mockCharacter2]
        subject.coordinator = mockCoordinator

        let indexPath = IndexPath(row: 1, section: 0)
        subject.tableView(subject.tableView, didSelectRowAt: indexPath)
        XCTAssert(mockCoordinator.showCharacterDetailsCalled)
        XCTAssertEqual(mockCoordinator.characterPassed, mockCharacter2)
    }

    func testDidFetchCharactersUpdatesViewModelAndReloadsTableView() {
        let mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: nil)
        let mockCharacter2 = Character(name: "Test2", description: "Description2", imageURL: "www.blah.com/test2.jpg", image: nil)
        let mockTableView = MockUITableView()
        let mockDispatcher = MockDispatcher()

        subject.characterListViewModel.characters = []
        subject.tableView = mockTableView
        subject.mainDispatcher = mockDispatcher

        let expectedCharacters = [mockCharacter, mockCharacter2]
        subject.didFetchCharacters(characters: [mockCharacter, mockCharacter2], error: nil)

        XCTAssert(subject.characterListViewModel.characters == expectedCharacters)
    }
}
