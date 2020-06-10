//
//  ListViewController.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import UIKit

// MARK: Delegated actions

protocol CharacterListViewControllerDelegate: AnyObject {
    func didTapCharacter(character: Character)
    func didTapWebsite(url: URL)
}

class CharacterListViewController: UITableViewController, CharacterListViewModelDelegate {

    //MARK: Properties
    weak var delegate: CharacterListViewControllerDelegate?
    var characterListViewModel: CharacterListViewModelProtocol
    var mainDispatcher: Dispatcher

    init(characterListViewModel: CharacterListViewModelProtocol = CharacterListViewModel(),
         mainDispatcher: Dispatcher = MainDispatcher()) {
        self.characterListViewModel = characterListViewModel
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
        tableView.showsVerticalScrollIndicator = false
        characterListViewModel.delegate = self
        characterListViewModel.getCharacters()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    // MARK: - Datasource

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
        delegate?.didTapCharacter(character: character)
    }

    // MARK: ViewModel delegate
    func didUpdateCharacters() {
        mainDispatcher.async {
            self.tableView.reloadData()
        }
    }
}
