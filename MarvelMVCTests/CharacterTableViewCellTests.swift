//
//  CharacterTableViewCellTests.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 05/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import XCTest

@testable import MarvelMVC

class CharacterTableViewCellTests: XCTestCase {

    var subject: CharacterTableViewCell!
    let testImage = UIImage(named: "blank")
    var mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: nil)

    override func setUp() {
        subject = CharacterTableViewCell()
    }
    
    func testTextAndImageViewsContainNameAndImage() {
        subject.configure(with: mockCharacter)
        XCTAssert(subject.textView.text == mockCharacter.name)
        XCTAssert(subject.imageView?.image == mockCharacter.image)
    }

    func testActivtyIndicatorIsAnimatingWhenNoImagePresent() {
        subject.configure(with: mockCharacter)
        XCTAssert(subject.activityIndicatorView.isAnimating == true)
    }

    func testActivtyIndicatorIsNotAnimatingWhenImagePresent() {
        mockCharacter = Character(name: "Test", description: "Description", imageURL: "www.blah.com/test.jpg", image: testImage)
        subject.configure(with: mockCharacter)
        XCTAssert(subject.activityIndicatorView.isAnimating == false)
    }
}
