//
//  Coordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 10.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var viewController: UIViewController? { get }
    var childCoordinators: [Coordinator] { get }
    var parent: Coordinator? { get }

    func start(animated: Bool)
    func handle(event: Event)
}

class Event {}
