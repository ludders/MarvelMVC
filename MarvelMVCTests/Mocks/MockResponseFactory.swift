//
//  MockResponseFactory.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 20/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class MockHTTPURLResponseFactory {
    static var successJSONResponse: HTTPURLResponse {
        let response = HTTPURLResponse(url: URL(fileURLWithPath: ""),
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])
        return response!
    }

    static var failureJSONResponse: HTTPURLResponse {
        let response = HTTPURLResponse(url: URL(fileURLWithPath: ""),
                                       statusCode: 500,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])
        return response!
    }

    static var successImageResponse: HTTPURLResponse {
        let response = HTTPURLResponse(url: URL(fileURLWithPath: "http://test.com/test.jpg"),
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "image/jpeg"])
        return response!
    }

    static var failureImageResponse: HTTPURLResponse {
        let response = HTTPURLResponse(url: URL(fileURLWithPath: "http://test.com/test.jpg"),
                                       statusCode: 500,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "image/jpeg"])
        return response!
    }

    static var failureImageMIMEResponse: HTTPURLResponse {
        let response = HTTPURLResponse(url: URL(fileURLWithPath: "http://test.com/test.json"),
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])
        return response!
    }
}
