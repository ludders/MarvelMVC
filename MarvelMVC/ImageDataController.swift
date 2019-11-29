//
//  ImageDataController.swift
//  MarvelMVC
//
//  Created by dludlow7 on 05/12/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterImageDataControllable {
    var defaultImage: UIImage? { get set }
    var delegate: CharacterImageDataControllerDelegate? { get set }
    func fetchImage(for character: Character)
}

protocol CharacterImageDataControllerDelegate {
    func didFetchImage(for character: Character, image: UIImage?)
}

class CharacterImageDataController: CharacterImageDataControllable {

    var defaultImage: UIImage?
    var delegate: CharacterImageDataControllerDelegate?

    func fetchImage(for character: Character) {

        guard let urlString = character.imageURL,
            let url = URL(string: urlString) else {
                delegate?.didFetchImage(for: character, image: defaultImage)
                return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
            }

            if let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let mimeType = httpResponse.mimeType,
                mimeType.hasPrefix("image/"),
                let imageData = data {

                    let image = UIImage(data: imageData)
                    self.delegate?.didFetchImage(for: character, image: image)
            }
        }
        task.resume()
    }
}
