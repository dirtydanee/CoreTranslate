//
//  ObservationResultsCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 05.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class ObservationResultsCoordinator: Coordinator {

    let observationStore: ObservationStore
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    private var observationResultsViewController: ObservationResultsViewController?

    init(navigationController: UINavigationController, observationStore: ObservationStore) {
        self.observationStore = observationStore
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    func start(animated: Bool) {
        let viewPresentations = self.observationStore.observations.map { ObservationViewPresentation(observation: $0) }
        let viewController = ObservationResultsViewController(viewPresentations: viewPresentations)
        viewController.delegate = self
        self.navigationController.pushViewController(viewController, animated: animated)
        self.observationResultsViewController = viewController
    }

    private func presentTranslations(for observation: Observation) {
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

extension ObservationResultsCoordinator: ObservationResultsViewControllerDelegate {
    func observationResultsViewController(_ viewController: ObservationResultsViewController,
                                          didSelectObservation observation: Observation) {
        self.presentTranslations(for: observation)
    }
}
