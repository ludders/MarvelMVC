//
//  CharacterListCoordinator.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import SafariServices
import UIKit

protocol CharacterListViewControllerDelegate: AnyObject {
    func didTapCharacter(character: Character)
    func didTapWebsite(url: URL)
}

class MainCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = CharacterListViewModel()
        let viewController = CharacterListViewController(characterListViewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator: CharacterListViewControllerDelegate {
    func didTapCharacter(character: Character) {
        let viewController = DetailViewController(character: character)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func didTapWebsite(url: URL) {
        let viewController = SFSafariViewController(url: url)
        navigationController.pushViewController(viewController, animated: true)
    }
}
