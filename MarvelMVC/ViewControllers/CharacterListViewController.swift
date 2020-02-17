//
//  ListViewController.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import UIKit

class CharacterListViewController: UITableViewController, UITableViewDataSourcePrefetching, CharacterDataControllerDelegate, CharacterImageDataControllerDelegate {

    var characterListViewModel = CharacterListViewModel()
    var dataController: CharacterDataControllable!
    var imageDataController: CharacterImageDataControllable!
    var defaultCharacterImage: UIImage? = UIImage(named: "characterDefault")

    init() {
        self.dataController = characterListViewModel.dataController
        self.imageDataController = characterListViewModel.imageDataController
        super.init(nibName: nil, bundle: Bundle.main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Characters"
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterTableViewCell")
        imageDataController.defaultImage = defaultCharacterImage
        self.dataController.delegate = self
        self.imageDataController.delegate = self
        characterListViewModel.dataController.fetchCharacters()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterListViewModel.characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell", for: indexPath) as? CharacterTableViewCell else {
            fatalError("Failed to dequeue CharacterTableViewCell from tableView")
        }

        let character = characterListViewModel.characters[indexPath.row]
        if character.image == nil {
            characterListViewModel.imageDataController.fetchImage(for: character)
        }
        cell.configure(with: character)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(character: characterListViewModel.characters[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    // MARK: - Table view data source prefetching function(s)

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let character = characterListViewModel.characters[indexPath.row]
            if character.image == nil {
                characterListViewModel.imageDataController.fetchImage(for: character)
            }
        }
    }

    // MARK: - Character Image Data Controller delegate function(s)

    func didFetchImage(for character: Character, image: UIImage?) {
        guard let index = characterListViewModel.characters.firstIndex(where: { char -> Bool in
            return character == char
        }) else { return }

        characterListViewModel.characters[index].image = image

        DispatchQueue.main.async {
            let cell = self.tableView(self.tableView, cellForRowAt: IndexPath(row: index, section: 0)) as? CharacterTableViewCell
            cell?.activityIndicatorView.isHidden = true
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }

    func didFetchCharacters(characters: [Character]) {
        characterListViewModel.characters = characters
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
