//
//  CharacterListCoordinator.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

// The purpose of this protocol is to allow someone to show characte details
// So you don't necessarily need to conform to `Coordinator` too here.
// For example, in `CharacterListViewController` you inject something that conforms to `CharacterListCoordinatorProtocol`
// Now `CharacterListViewController` can call `start()` or `childCoordinators` on the `CharacterListCoordinatorProtocol`
// but it doesn't really need to know that information. It only wants to `showCharacterDetails(character: Character)`
// So more often you see this kind of setup
/*
protocol CharacterListViewControllerDelegate {
    func showCharacterDetails(character: Character)
}

class CharacterListCoordinator: Coordinator {
    ...
}

extension CharacterListCoordinator: CharacterListViewControllerDelegate {
    func showCharacterDetails(character: Character)
}
 */

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

