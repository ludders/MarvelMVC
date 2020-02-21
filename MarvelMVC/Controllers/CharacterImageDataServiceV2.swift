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
    func fetchImage(for character: Character, onSuccess: @escaping (UIImage?) -> Void, onFailure: @escaping (Error) -> ())
}

class CharacterImageDataServiceV2: CharacterImageDataServiceProtocolV2 {

    var defaultImage: UIImage?
    var urlSession: URLSession

    required init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchImage(for character: Character, onSuccess: @escaping (UIImage?) -> Void, onFailure: @escaping (Error) -> ()) {

        guard let urlString = character.imageURL,
            let url = URL(string: urlString) else {
                onSuccess(defaultImage)
                return
        }

        let task = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                onFailure(error)
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "",
                                    code: 0,
                                    userInfo: ["localizedDescription": "Unexpected response type recieved"])
                onFailure(error)
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "",
                                    code: httpResponse.statusCode,
                                    userInfo: ["localizedDescription": "HTTP Status Error \(httpResponse.statusCode)"])
                onFailure(error)
                return
            }

            if let mimeType = httpResponse.mimeType,
                mimeType.hasPrefix("image/"),
                let imageData = data {

                let image = UIImage(data: imageData)
                onSuccess(image)
            }
        }
        task.resume()
    }
}
