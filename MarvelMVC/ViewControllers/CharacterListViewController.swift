//
//  ListViewController.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import UIKit

class CharacterListViewController: UITableViewController, UITableViewDataSourcePrefetching, CharacterDataServiceDelegate {

    var coordinator: CharacterListCoordinatorProtocol
    var characterListViewModel: CharacterListViewModelProtocol
    var defaultCharacterImage: UIImage? = UIImage(named: "characterDefault")
    var mainDispatcher: Dispatcher = MainDispatcher()

    init(characterListViewModel: CharacterListViewModelProtocol = CharacterListViewModel(),
         coordinator: CharacterListCoordinatorProtocol) {
        self.characterListViewModel = characterListViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: Bundle.main)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Characters"
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterTableViewCell")
        characterListViewModel.imageDataService.defaultImage = defaultCharacterImage
        characterListViewModel.dataService.delegate = self
        characterListViewModel.dataService.fetchCharacters()
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
            fetchCharacterImageAndUpdateTableRow(character: character, indexPathForRow: indexPath)
        }
        cell.configure(with: character)

        return cell
    }

    func fetchCharacterImageAndUpdateTableRow(character: Character, indexPathForRow indexPath: IndexPath) {
        characterListViewModel.imageDataService.fetchImage(for: character, onSuccess: { image in
            self.characterListViewModel.characters[indexPath.row].image = image
            self.updateTableRow(for: character)
        }, onFailure: { error in
            print(error)
        })
    }

    func updateTableRow(for character: Character) {
        if let row = self.characterListViewModel.characters.firstIndex(of: character) {
            let indexPath = IndexPath(row: row, section: 0)
            mainDispatcher.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characterListViewModel.characters[indexPath.row]
        coordinator.showCharacterDetails(character: character)
    }

    // MARK: - Table view data source prefetching function(s)

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let character = characterListViewModel.characters[indexPath.row]
            if character.image == nil {
                characterListViewModel.imageDataService.fetchImage(for: character, onSuccess: { [weak self] image in
                    self?.characterListViewModel.characters[indexPath.row].image = image
                }) { error in
                    print(error)
                }
            }
        }
    }

    // MARK: - Character Data Service delegate function(s

    func didFetchCharacters(characters: [Character]?, error: Error?) {
        guard let characters = characters else { return }
        characterListViewModel.characters = characters
        mainDispatcher.async {
            self.tableView.reloadData()
        }
    }
}
