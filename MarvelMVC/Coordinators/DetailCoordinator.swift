//
//  DetailCoordinator.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

class DetailCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    var character: Character

    init(navigationController: UINavigationController,
         character: Character) {
        self.navigationController = navigationController
        self.character = character
    }

    func start() {
        let viewController = DetailViewController(character: character)
        navigationController.pushViewController(viewController, animated: true)
    }
}
