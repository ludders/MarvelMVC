//
//  CharacterImageDataServiceV2.swift
//  MarvelMVC
//
//  Created by dludlow7 on 21/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterImageDataServiceProtocolV2 {
    var defaultImage: UIImage? { get set }
    func fetchImage(for character: Character,
                    onSuccess: ((UIImage?) -> ())?,
                    onFailure: ((Error) -> ())?)
}

class CharacterImageDataServiceV2: CharacterImageDataServiceProtocolV2 {

    var defaultImage: UIImage?
    private let urlSession: URLSession

    required init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchImage(for character: Character, onSuccess: ((UIImage?) -> Void)?, onFailure: ((Error) -> ())?) {

        guard let urlString = character.imageURL,
            let url = URL(string: urlString) else {
                onSuccess?(defaultImage)
                return
        }

        let task = urlSession.dataTask(with: url) { data, response, error in

            if let error = error {
                onFailure?(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                onFailure?(NetworkErrors.unexpectedResponseType())
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                onFailure?(NetworkErrors.httpStatusError(statusCode: httpResponse.statusCode))
                return
            }
            if let mimeType = httpResponse.mimeType {
                guard mimeType.hasPrefix("image/") else {
                    onFailure?(NetworkErrors.unexpectedMIMEType(mimeType: mimeType))
                    return
                }
                guard let imageData = data else {
                    onFailure?(NetworkErrors.dataDecodeError())
                    return
                }
                let image = UIImage(data: imageData)
                onSuccess?(image)
            }
        }
        task.resume()
    }
}
