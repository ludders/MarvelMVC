//
//  CharacterCellTableViewCell.swift
//  MarvelMVC
//
//  Created by dludlow7 on 21/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {

    func configure(character: Character) {
        textLabel?.text = character.name ?? "No Name"
        imageView?.image = character.image
    }
}
