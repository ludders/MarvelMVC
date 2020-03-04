//
//  MockCharacterImageDataService.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 05/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import MarvelMVC

class MockCharacterImageDataService: CharacterImageDataServiceProtocolV2 {

    var defaultImage: UIImage?
    var fetchImageBehaviour: FetchImageBehaviour = .shouldFailWithError(NetworkErrors.httpStatusError(statusCode: 500))
    var fetchImageCalled: Bool = false
    var fetchImageExpectation = XCTestExpectation(description: "MockCharacterImageDataService fetchImage expectation")

    public init(defaultImage: UIImage? = nil) {
        self.defaultImage = defaultImage
    }

    func fetchImage(for character: Character, onSuccess: ((UIImage?) -> ())?, onFailure: ((Error) -> ())?) {
        switch fetchImageBehaviour {
        case .shouldSucceedWithImage(let image):
            onSuccess?(image)
        case .shouldFailWithError(let error):
            onFailure?(error)
        }
        fetchImageExpectation.fulfill()
    }
}

enum FetchImageBehaviour {
    case shouldFailWithError(Error)
    case shouldSucceedWithImage(UIImage)
}
