//
//  CharacterDataControllerTests.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 18/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import XCTest
@testable import MarvelMVC

class CharacterDataControllerTests: XCTestCase {

    var subject: CharacterDataService!
    var mockDelegate = MockCharacterDataServiceDelegate()
    var mockURLSession: MockURLSession!

    func testFetchCharactersWithSuccessfulResponse() {
        let data = MockResourceDataProvider.data(fromFile: "MockCharacterData", ofType: ".json")
        let response = MockHTTPURLResponseFactory.successResponse
        mockURLSession = MockURLSession(mockData: data,
                                        mockResponse: response,
                                        mockError: nil)

        subject = CharacterDataService(urlSession: mockURLSession)
        subject.delegate = mockDelegate
        subject.fetchCharacters()
        XCTAssert(mockDelegate.didFetchCharactersCalled)
        XCTAssertNil(mockDelegate.error)
    }

    func testFetchCharactersWithUnsuccessfulResponse() {
        let response = MockHTTPURLResponseFactory.failureResponse
        mockURLSession = MockURLSession(mockData: nil,
                                        mockResponse: response,
                                        mockError: nil)
        let expectedError = NSError(domain: "", code: 500, userInfo: ["localizedDescription": "HTTP Status Error 500"])

        subject = CharacterDataService(urlSession: mockURLSession)
        subject.delegate = mockDelegate
        subject.fetchCharacters()
        XCTAssert(mockDelegate.didFetchCharactersCalled)
        XCTAssert(mockDelegate.error?.isEqualTo(expectedError) ?? false)
    }

    func testFetchCharactersWithURLSessionError() {
        let sessionError =  NSError(domain: "Test", code: 123, userInfo: nil)
        mockURLSession = MockURLSession(mockData: nil, mockResponse: nil, mockError: sessionError)

        subject = CharacterDataService(urlSession: mockURLSession)
        subject.delegate = mockDelegate
        subject.fetchCharacters()
        XCTAssert(mockDelegate.didFetchCharactersCalled)
        XCTAssert(mockDelegate.error?.isEqualTo(sessionError) ?? false)
    }

    func testFetchCharactersWithNonHTTPResponseTypeRecieved() {
        let response = URLResponse()
        mockURLSession = MockURLSession(mockData: nil,
                                        mockResponse: response,
                                        mockError: nil)
        let expectedError = NSError(domain: "",
                                    code: 0,
                                    userInfo: ["localizedDescription": "Unexpected response type recieved"])

        subject = CharacterDataService(urlSession: mockURLSession)
        subject.delegate = mockDelegate
        subject.fetchCharacters()
        XCTAssert(mockDelegate.didFetchCharactersCalled)
        XCTAssert(mockDelegate.error?.isEqualTo(expectedError) ?? false)
    }
}

extension Error {
    func isEqualTo(_ error: Error) -> Bool {
        return String(describing: self) == String(describing: error)
    }
}
