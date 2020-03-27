//
//  CharacterTableViewCell.swift
//  MarvelMVC
//
//  Created by dludlow7 on 02/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    var lastReuseID: String? = nil
    let imageContainerView: UIView = UIView()
    var characterImageView: UIImageView = UIImageView()
    let textView: UILabel = UILabel()
    let activityIndicatorView = UIActivityIndicatorView(style: .large)

    override func prepareForReuse() {
        imageView?.image = nil
        textView.text = nil
        lastReuseID = UUID().uuidString
        activityIndicatorView.startAnimating()
        super.prepareForReuse()
    }

    public func configure(with character: Character) {
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(characterImageView)
        contentView.addSubview(textView)
        contentView.addSubview(activityIndicatorView)

        configureImageContainerView()
        configureCharacterImageView(withImage: character.image)
        configureActivityIndicatorView()
        configureTextView(withText: character.name)
    }

    private func configureImageContainerView() {
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false

        let imageContainerViewConstraints: [NSLayoutConstraint] = [
            imageContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),
            imageContainerView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(imageContainerViewConstraints)
    }

    private func configureCharacterImageView(withImage image: UIImage?) {
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.image = image
        characterImageView.contentMode = .scaleToFill

        let characterImageViewConstraints: [NSLayoutConstraint] = [
            characterImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            characterImageView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            characterImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor)
        ]
        NSLayoutConstraint.activate(characterImageViewConstraints)
    }

    private func configureActivityIndicatorView() {
        activityIndicatorView.color = UIColor.red
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        let activityIndicatorViewConstraints: [NSLayoutConstraint] = [
            activityIndicatorView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            activityIndicatorView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor)

        ]
        NSLayoutConstraint.activate(activityIndicatorViewConstraints)

        if characterImageView.image == nil {
            activityIndicatorView.startAnimating()
        }
    }

    private func configureTextView(withText name: String?) {
        textView.text = name
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false

        let textViewConstraints: [NSLayoutConstraint] = [
            textView.leadingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(textViewConstraints)
    }
}
