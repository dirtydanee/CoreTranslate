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
        let viewPresentations = self.createViewPresentations(from: self.observationStore.observations)
        print(viewPresentations)
        let viewController = ObservationResultsViewController(viewPresentations: viewPresentations)
        self.navigationController.pushViewController(viewController, animated: animated)
        self.observationResultsViewController = viewController
    }

    private func createViewPresentations(from observations: Set<Observation>) -> [ObservationViewPresentation] {
        return observations.map { return ObservationViewPresentation(observation: $0) }
    }
}
