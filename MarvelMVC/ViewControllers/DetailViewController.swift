//
//  DetailViewController.swift
//  MarvelMVC
//
//  Created by dludlow7 on 24/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

//TODO: Fix constraint issues (Image View)

import UIKit

class DetailViewController: UIViewController {

    var contentView: UIView!
    var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    var nameLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    var descriptionLabel: UILabel = {
        let view = UILabel(frame: CGRect.zero)
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return view
    }()
    var websiteButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Go To Website", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        return button
    }()
    var character: Character
    var websiteURL: URL?
    var coordinator: CharacterListCoordinatorProtocol

    init(character: Character, coordinator: CharacterListCoordinatorProtocol) {
        self.character = character
        self.coordinator = coordinator
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
        navigationItem.largeTitleDisplayMode = .never
        contentView.backgroundColor = UIColor.white
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        setupConstraints()
        fillCharacterData()
        setupButton()
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

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let nameLabelConstraints: [NSLayoutConstraint] = [
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        NSLayoutConstraint.activate(nameLabelConstraints)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        let descriptionViewConstraints: [NSLayoutConstraint] = [
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(descriptionViewConstraints)

        websiteButton.translatesAutoresizingMaskIntoConstraints = false
        let websiteButtonConstraints: [NSLayoutConstraint] = [
            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            websiteButton.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, constant: -20),
            websiteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        NSLayoutConstraint.activate(websiteButtonConstraints)
    }

    func fillCharacterData() {
        imageView.image = character.image
        nameLabel.attributedText = NSAttributedString(string: character.name!,
                                                      attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        descriptionLabel.text = character.description
    }

    func setupButton() {
        if let urlString = character.detailURL {
            websiteURL = URL(string: urlString)
            websiteButton.addTarget(self, action: #selector(onWebsiteButtonTapped), for: .touchUpInside)
        } else {
            websiteButton.isEnabled = false
        }
    }

    @objc func onWebsiteButtonTapped() {
        guard let websiteURL = websiteURL else { return }
        coordinator.showWebBrowser(url: websiteURL)
    }
}
