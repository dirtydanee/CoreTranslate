//
//  AppCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 10.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    private(set) var childCoordinators: [Coordinator]
    let navigationController: UINavigationController
    let window: UIWindow
    
    init(window: UIWindow) {
        self.navigationController = UINavigationController()
        self.window = window
        self.childCoordinators = []
    }

    func start(animated: Bool) {

        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()

        let takePhotoCoordinator = TakePhotoCoordinator(navigationController: self.navigationController)
        takePhotoCoordinator.start(animated: false)
        self.childCoordinators.append(takePhotoCoordinator)
    }
}
