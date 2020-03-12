//
//  CharacterListCoordinator.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterListCoordinatorProtocol : Coordinator {
    func showCharacterDetails(character: Character)
}

class CharacterListCoordinator: CharacterListCoordinatorProtocol {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    var viewModel: CharacterListViewModelProtocol

    init(navigationController: UINavigationController,
         viewModel: CharacterListViewModelProtocol = CharacterListViewModel()) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    func start() {
        let viewController = CharacterListViewController(characterListViewModel: viewModel, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showCharacterDetails(character: Character) {
        let viewController = DetailViewController(character: character)
        navigationController.pushViewController(viewController, animated: true)
    }
}
