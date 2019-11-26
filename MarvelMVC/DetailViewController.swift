//
//  DetailViewController.swift
//  MarvelMVC
//
//  Created by dludlow7 on 24/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var contentView: UIView!
    var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    var descriptionView: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.numberOfLines = 0
        return view
    }()
    var character: Character

    init(character: Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        contentView = UIView(frame: UIScreen.main.bounds)
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = UIColor.white
        view.addSubview(imageView)
        view.addSubview(descriptionView)
        setupConstraints()
        imageView.image = character.image
        descriptionView.text = character.description
    }

    func setupConstraints() {

        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewConstraints: [NSLayoutConstraint] = [
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
        ]
        NSLayoutConstraint.activate(imageViewConstraints)

        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        let descriptionViewConstraints: [NSLayoutConstraint] = [
            descriptionView.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.bottomAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            descriptionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, constant: -20),
            descriptionView.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
        ]
        NSLayoutConstraint.activate(descriptionViewConstraints)
    }
}
