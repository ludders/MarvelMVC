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
    var defaultCharacterImage: UIImage? = UIImage(named: "characterDefault") // This could be managed by the cell, unless you're thinking the cell will be reused for other model, which would be fair in a bigger app
    var mainDispatcher: Dispatcher = MainDispatcher()

    init(characterListViewModel: CharacterListViewModelProtocol = CharacterListViewModel(),
         coordinator: CharacterListCoordinatorProtocol) {
        self.characterListViewModel = characterListViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: Bundle.main) // think bundle can be nil actually
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

    
    /*
     There's something a bit funny going on here :)
     
     When you first load the app, this method is called. Let's say for Thor.
     The image is nil so you fetch the image.
     The cell.configure is called for Thor while the image is fetched.
     When the image is fetched you call this `self.tableView.reloadRows(at: [indexPath], with: .automatic)`
     Which in turn calls this `func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell` again
     Not the image is not nil so you don't fetch again
     But you do configure the cell again.
     Which is slightly suboptimal.
     
     Question is can you update the image on the cell without reloading the whole cell again? Yes there are a few ways
     
     Here's a hacky way I tried that doesn't handle you're loading view image nor any caching but still :)
             if character.image == nil {
                 DispatchQueue.main.async {
                     let image = try? UIImage(data: Data(contentsOf: URL(string: character.imageURL!)!))
                     cell.characterImageView.image = image
                 }
     //            fetchCharacterImageAndUpdateTableRow(character: character, indexPathForRow: indexPath)
             }
     
     */
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
        characterListViewModel.characters = characters // This should be in the ViewModel, having this here is giving the `ViewController` the responsibility of updating the `ViewModel`, that ain't right maaaan. :)
        // This is a good example of where { get set } is giving too much flexibility and exposing too much of underlying objects.
        mainDispatcher.async {
            self.tableView.reloadData()
        }
    }
}
