//
//  ListViewController.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var characters = [Character]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Characters"
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "CharacterCell")
        fetchCharacters()
    }

    func fetchCharacters() {
        let url = URL(string: "https://gateway.marvel.com/v1/public/characters?ts=1&apikey=ff3d4847092294acc724123682af904b&hash=412b0d63f1d175474216fadfcc4e4fed&limit=25&orderBy=-modified")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { jsonData, response, error in
            if let error = error {
                print(error)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid Character API response")
                    return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                let jsonData = jsonData {

                let decoder = JSONDecoder()
                let characterResponse = try! decoder.decode(CharacterAPIResponse.self, from: jsonData)
                if let results = characterResponse.data?.results {
                    for result in results {
                        self.createCharacter(for: result)
                    }
                }
            }
        }
        task.resume()
    }

    func createCharacter(for result: CharacterData) {
        if let thumbnail = result.thumbnail {
            let url = URL(string: "\(thumbnail.path).\(thumbnail.thumbnailExtension)")!
            let task = URLSession.shared.dataTask(with: url) { imageData, response, error in
                if let error = error {
                    print(error)
                }

                let image: UIImage?

                if let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode),
                    let mimeType = httpResponse.mimeType,
                    mimeType.contains("image/"),
                    let imageData = imageData {
                    image = UIImage(data: imageData)
                } else {
                    image = UIImage(named: "anonymous")
                }
                let character = Character(name: result.name, description: result.description, image: image)
                self.characters.append(character)
            }
            task.resume()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as? CharacterCell else {
            fatalError("Failed to dequeue CharacterCell from tableView")
        }
        cell.configure(character: characters[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(character: characters[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
