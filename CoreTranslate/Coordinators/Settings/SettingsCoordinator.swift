//
//  SettingsCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 21.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class SettingsCoordinator: Coordinator {

    var viewController: UIViewController? {
        return self.settingsViewController
    }

    let parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    private var settingsViewController: UIViewController?

    init(parent: Coordinator?) {
        self.parent = parent
    }

    func start(animated: Bool) {
        self.settingsViewController = UIViewController()
    }

    func handle(event: Event) {
        //TODO: Handle event
    }
}
