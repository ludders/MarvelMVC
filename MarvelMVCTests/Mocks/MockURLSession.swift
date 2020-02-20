//
//  MockURLSession.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 18/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class MockURLSession: URLSession {

    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    init(mockData: Data?, mockResponse: URLResponse?, mockError: Error?) {
        self.mockData = mockData
        self.mockResponse = mockResponse
        self.mockError = mockError
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        let task = MockURLSessionDataTask(session: self,
                                          mockData: mockData,
                                          mockResponse: mockResponse,
                                          mockError: mockError,
                                          completionHandler: completionHandler)
        return task
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    var session: MockURLSession
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    var completionHandler: (Data?, URLResponse?, Error?) -> Void

    init(session: MockURLSession,
         mockData: Data?,
         mockResponse: URLResponse?,
         mockError: Error?,
         completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.session = session
        self.mockData = mockData
        self.mockResponse = mockResponse
        self.mockError = mockError
        self.completionHandler = completionHandler
    }

    override func resume() {
        completionHandler(mockData, mockResponse, mockError)
    }
}
