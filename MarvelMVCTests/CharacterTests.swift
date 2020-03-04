//
//  CharacterTests.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 05/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import XCTest

@testable import MarvelMVC

class CharacterTests: XCTestCase {

    func testCharacterEqualityWhenCharactersAreEqual() {
        let character = Character(name: "Test",
                                  description: "Description",
                                  imageURL: "www.test.com/test.jpg",
                                  image: nil)
        let character2 = Character(name: "Test",
                                   description: "Description",
                                   imageURL: "www.test.com/test.jpg",
                                   image: nil)
        
        XCTAssertTrue(character == character2)
    }

    func testCharacterEqualityWhenCharactersAreNotEqual() {
        let character = Character(name: "Test",
                                  description: "Description",
                                  imageURL: "www.test.com/test.jpg",
                                  image: nil)
        let characterDifferentName = Character(name: "Blah",
                                               description: "Description",
                                               imageURL: "www.test.com/test.jpg",
                                               image: nil)
        let characterDifferentDescription = Character(name: "Test",
                                                      description: "Blah",
                                                      imageURL: "www.test.com/test.jpg",
                                                      image: nil)
        let characterDifferentURL = Character(name: "Test2",
                                              description: "Description",
                                              imageURL: "Blah",
                                              image: nil)

        XCTAssertFalse(character == characterDifferentName)
        XCTAssertFalse(character == characterDifferentDescription)
        XCTAssertFalse(character == characterDifferentURL)
    }

}
