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

//        let takePhotoCoordinator = TakePhotoCoordinator(navigationController: self.navigationController)
//        takePhotoCoordinator.start(animated: false)
//        self.childCoordinators.append(takePhotoCoordinator)

        let observation = Observation(uuid: UUID(), identifier: "potato", confidence: 0.2, capturedImageData: Data())
        let translationConfiguration = TranslationConfiguration(baseURL: ApplicationConfiguration.baseTranslationURL,
                                                                fromLanguage: ApplicationConfiguration.baseLanguage,
                                                                toLanguage: .hungarian)
        let translationCoordinator = TranslationCoordinator(navigationController: self.navigationController,
                                                            observationToTranslate: observation,
                                                            withConfiguration: translationConfiguration)
        translationCoordinator.start(animated: true)
        self.childCoordinators.append(translationCoordinator)
    }
}
