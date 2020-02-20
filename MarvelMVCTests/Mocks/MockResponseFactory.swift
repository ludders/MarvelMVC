//
//  MockResponseFactory.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 20/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class MockHTTPURLResponseFactory {
    static var successResponse: HTTPURLResponse {
        let response = HTTPURLResponse(url: URL(fileURLWithPath: ""),
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])
        return response!
    }

    static var failureResponse: HTTPURLResponse {
        let response = HTTPURLResponse(url: URL(fileURLWithPath: ""),
                                       statusCode: 500,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])
        return response!
    }
}
