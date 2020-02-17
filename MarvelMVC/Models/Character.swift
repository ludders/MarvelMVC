//
//  Character.swift
//  MarvelMVC
//
//  Created by dludlow7 on 24/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

struct Character: Equatable {
    var name: String?
    var description: String?
    var imageURL: String?
    var image: UIImage?

    static func == (lhs: Character, rhs: Character) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.description == rhs.description &&
            lhs.imageURL == rhs.imageURL
    }
}
