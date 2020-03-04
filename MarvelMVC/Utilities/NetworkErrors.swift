//
//  NetworkErrors.swift
//  MarvelMVC
//
//  Created by dludlow7 on 05/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

final class NetworkErrors: NSError {

    static func unexpectedResponseType() -> NSError {

        return NSError(domain: "",
                       code: 0,
                       userInfo: ["localizedDescription": "Unexpected response type recieved"])
    }

    static func httpStatusError(statusCode: Int) -> NSError {
        return NSError(domain: "",
                       code: statusCode,
                       userInfo: ["localizedDescription": "HTTP Status Error \(statusCode)"])
    }

    static func unexpectedMIMEType(mimeType: String) -> NSError {
        return NSError(domain: "",
                       code: 0,
                       userInfo: ["localizedDescription": "Unexpected response MIME type: \(mimeType)"])
    }

    static func dataDecodeError() -> NSError {
        return NSError(domain: "",
                       code: 0,
                       userInfo: ["localizedDescription": "Failed to decode response data"])
    }
}
