//
//  ListViewController.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, CharacterModelDelegate {

    let characterModel = CharacterModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Characters"
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "CharacterCell")
        characterModel.delegate = self
        characterModel.fetchCharacters()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterModel.characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as? CharacterCell else {
            fatalError("Failed to dequeue CharacterCell from tableView")
        }
        cell.configure(character: characterModel.characters[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(character: characterModel.characters[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    func didFetchCharacters(characters: [Character]) {
        print("Characters fetched! \(characters.count)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
