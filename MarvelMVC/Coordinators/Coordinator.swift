//
//  Coordinator.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set } // Don't normally need to expose this guy in the protocol

    func start()
}
