//
//  NetworkErrors.swift
//  MarvelMVC
//
//  Created by dludlow7 on 05/03/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation


// Your basically using a class for namespacing. So the class does nothing other than provide you with the syntax
// `NetworkErrors.unexpectedResponseType()`. You could use a struct, enum or even a typealias of NSError to achieve a similar thing.
// Not a big deal just a note.
final class NetworkErrors: NSError {

    // Whenever you have a function that takes no parameter but returns something you can make it a computed var
    // so the below would be `static var unexpectedResponseType: NSError` then the same body.
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

    // Same here
    static func dataDecodeError() -> NSError {
        return NSError(domain: "",
                       code: 0,
                       userInfo: ["localizedDescription": "Failed to decode response data"])
    }
}
