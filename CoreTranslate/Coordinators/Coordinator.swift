//
//  Coordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 10.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get }

    func start(animated: Bool)
}
