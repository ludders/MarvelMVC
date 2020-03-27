//
//  CharacterImageDataServiceV2Tests.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 21/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import XCTest
@testable import MarvelMVC

class CharacterImageDataServiceV2Tests: XCTestCase {

    var subject: CharacterImageDataServiceV2!

    func testFetchImageWithSuccessfulResponse() {
        let mockImageData = UIImage(named: "blank")?.jpegData(compressionQuality: 1.0)
        let mockResponse = MockHTTPURLResponseFactory.successImageResponse
        let mockURLSession: URLSession = MockURLSession(mockData: mockImageData,
                                            mockResponse: mockResponse,
                                            mockError: nil)

        let mockCharacter = Character(name: "Captain Test",
                                  description: "Loves 2 Test",
                                  imageURL: "http://test.com/test.jpg",
                                  image: nil)

        var testImage: UIImage?
        subject = CharacterImageDataServiceV2(urlSession: mockURLSession)
        subject.fetchImage(for: mockCharacter, onSuccess: { image in
            testImage = image
        }, onFailure: nil)

        XCTAssertNotNil(testImage)
    }

    func testFetchImageWithNoURLReturnsDefaultImage() {
        let mockURLSession: URLSession = MockURLSession(mockData: nil,
                                                        mockResponse: nil,
                                                        mockError: nil)
        let mockCharacter = Character(name: nil,
                                  description: nil,
                                  imageURL: nil,
                                  image: nil)

        var testImage: UIImage?
        subject = CharacterImageDataServiceV2(urlSession: mockURLSession)
        subject.defaultImage = UIImage(named: "blank")
        subject.fetchImage(for: mockCharacter, onSuccess: { image in
            testImage = image
        }, onFailure: nil)

        XCTAssert(testImage === subject.defaultImage)
    }

    func testFetchImageWithUnsuccessfulResponse() {
        let mockResponse = MockHTTPURLResponseFactory.failureImageResponse
        let mockURLSession: URLSession = MockURLSession(mockData: nil,
                                                        mockResponse: mockResponse,
                                                        mockError: nil)
        let mockCharacter = Character(name: nil,
                                  description: nil,
                                  imageURL: "http://test.com/test.jpg",
                                  image: nil)
        subject = CharacterImageDataServiceV2(urlSession: mockURLSession)

        let expectedError = NetworkErrors.httpStatusError(statusCode: 500)
        var actualError: Error?

        subject.fetchImage(for: mockCharacter, onSuccess: nil) { error in
            actualError = error
        }

        XCTAssert(actualError?.isEqualTo(expectedError) ?? false)
    }

    func testFetchImageWithNonHTTPResponseTypeRecieved() {
        let mockResponse = URLResponse()
        let mockURLSession: URLSession = MockURLSession(mockData: nil,
                                                        mockResponse: mockResponse,
                                                        mockError: nil)
        let mockCharacter = Character(name: nil,
                                  description: nil,
                                  imageURL: "http://test.com/test.jpg",
                                  image: nil)
        subject = CharacterImageDataServiceV2(urlSession: mockURLSession)

        let expectedError = NetworkErrors.unexpectedResponseType
        var actualError: Error?

        subject.fetchImage(for: mockCharacter, onSuccess: nil) { error in
            actualError = error
        }

        XCTAssert(actualError?.isEqualTo(expectedError) ?? false)
    }

    func testFetchImageWithNonImageMIMETypeRecieved() {
        let mockResponse = MockHTTPURLResponseFactory.failureImageMIMEResponse
        let mockURLSession: URLSession = MockURLSession(mockData: nil,
                                                        mockResponse: mockResponse,
                                                        mockError: nil)
        let mockCharacter = Character(name: nil,
                                      description: nil,
                                      imageURL: "http://test.com/test.jpg",
                                      image: nil)
        subject = CharacterImageDataServiceV2(urlSession: mockURLSession)

        let expectedError = NetworkErrors.unexpectedMIMEType(mimeType: "application/json")
        var actualError: Error?

        subject.fetchImage(for: mockCharacter, onSuccess: nil) { error in
            actualError = error
        }

        XCTAssert(actualError?.isEqualTo(expectedError) ?? false)
    }

    func testFetchCharactersWithURLSessionError() {
        let expectedError =  NSError(domain: "Test", code: 123, userInfo: nil)
        let mockURLSession = MockURLSession(mockData: nil,
                                            mockResponse: nil,
                                            mockError: expectedError)
        let mockCharacter = Character(name: nil,
                                      description: nil,
                                      imageURL: "http://test.com/test.jpg",
                                      image: nil)

        var actualError: Error?
        subject = CharacterImageDataServiceV2(urlSession: mockURLSession)
        subject.fetchImage(for: mockCharacter, onSuccess: nil) { error in
            actualError = error
        }

        XCTAssert(actualError?.isEqualTo(expectedError) ?? false)
    }

    func testFetchCharactersWithNilDataError() {
        let expectedError = NetworkErrors.dataDecodeError()
        let mockResponse = MockHTTPURLResponseFactory.successImageResponse
        let mockURLSession = MockURLSession(mockData: nil,
                                            mockResponse: mockResponse,
                                            mockError: nil)

        subject = CharacterImageDataServiceV2(urlSession: mockURLSession)
        let mockCharacter = Character(name: nil,
                                      description: nil,
                                      imageURL: "http://test.com/test.jpg",
                                      image: nil)

        var actualError: Error?
        subject.fetchImage(for: mockCharacter, onSuccess: nil) { error in
            actualError = error
        }

        XCTAssert(actualError?.isEqualTo(expectedError) ?? false)
    }
}
