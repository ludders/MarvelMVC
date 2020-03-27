//
//  ListViewController.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import UIKit

class CharacterListViewController: UITableViewController, CharacterListViewModelDelegate {

    var coordinator: CharacterListCoordinatorProtocol
    var characterListViewModel: CharacterListViewModelProtocol
    var defaultCharacterImage: UIImage? = UIImage(named: "characterDefault")
    var mainDispatcher: Dispatcher

    init(characterListViewModel: CharacterListViewModelProtocol = CharacterListViewModel(),
         coordinator: CharacterListCoordinatorProtocol,
         mainDispatcher: Dispatcher = MainDispatcher()) {
        self.characterListViewModel = characterListViewModel
        self.coordinator = coordinator
        self.mainDispatcher = mainDispatcher
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Characters"
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterTableViewCell")
        characterListViewModel.delegate = self
        characterListViewModel.getCharacters()
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
        cell.configure(with: character)
        let id = cell.lastReuseID
        characterListViewModel.getImage(for: character, onSuccess: { image in
            self.mainDispatcher.async {
                //Checks that the cell hasn't been reused by the time this block gets executed
                if id == cell.lastReuseID {
                    cell.characterImageView.image = image
                    cell.activityIndicatorView.stopAnimating()
                }
            }
        }) { error in
            print(error)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characterListViewModel.characters[indexPath.row]
        coordinator.showCharacterDetails(character: character)
    }

    // MARK: - CharacterListViewModel delegate function(s)

    func didUpdateCharacters() {
        mainDispatcher.async {
            self.tableView.reloadData()
        }
    }
}
