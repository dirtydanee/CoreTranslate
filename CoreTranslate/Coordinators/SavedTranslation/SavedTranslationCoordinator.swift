//
//  SavedTranslationCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 05.03.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class SavedTranslationCoordinator: Coordinator {

    var viewController: UIViewController? {
        return self.navigationController
    }

    var childCoordinators: [Coordinator]
    var parent: Coordinator?
    let translatedObservationStore: TranslatedObservationStore
    private var navigationController: UINavigationController? // TODO settle down on how this should be done -> See ScanCoordinator
    private var savedTranslationViewController: SavedTranslationViewController?

    init(translatedObservationStore: TranslatedObservationStore) {
        self.translatedObservationStore = translatedObservationStore
        self.childCoordinators = []
    }

    func start(animated: Bool) {
        let savedTranslationViewController = SavedTranslationViewController()
        let navigationController = UINavigationController(rootViewController: savedTranslationViewController)
        self.savedTranslationViewController = savedTranslationViewController
        self.navigationController = navigationController
    }

    func handle(event: Event) {
        // TODO: handle events
    }
}
