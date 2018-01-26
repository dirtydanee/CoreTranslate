//
//  ObservationResultsCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 05.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class ObservationResultsCoordinator: Coordinator {

    let parent: Coordinator?
    private(set) var childCoordinators: [Coordinator]
    var viewController: UIViewController? {
        return self.observationResultsViewController
    }

    let observationStore: ObservationStore
    let navigationController: UINavigationController
    let languageStore: LanguageStore

    private var observationResultsViewController: ObservationResultsViewController?
    private var toLanguage: Language?

    init(navigationController: UINavigationController,
         observationStore: ObservationStore,
         languageStore: LanguageStore,
         parent: Coordinator?) {
        self.navigationController = navigationController
        self.observationStore = observationStore
        self.languageStore = languageStore
        self.parent = parent
        self.toLanguage = languageStore.language(with: ApplicationConfiguration.preferredTargetLanguage)
        self.childCoordinators = []
    }

    func start(animated: Bool) {
        let viewPresentations = self.observationStore.observations.map { ObservationViewPresentation(observation: $0) }
        let viewController = ObservationResultsViewController(viewPresentations: viewPresentations)
        viewController.delegate = self
        self.navigationController.pushViewController(viewController, animated: animated)
        self.observationResultsViewController = viewController
    }

    func handle(event: Event) {
        switch event {
        case let event as LanguageSelectionEvent:
            self.toLanguage = event.language
            self.observationResultsViewController?.updateLanguage(to: event.language, atPosition: .to)
        default:
            break
        }
    }

    private func presentTranslations(for observation: Observation) {
        guard let toLanguage = self.toLanguage,
              let fromLanguage = languageStore.language(with: ApplicationConfiguration.baseLanguage) else {
            clog("Languages unselected", priority: .error)
            return
        }

        let translationConfiguration = TranslationConfiguration(baseURL: ApplicationConfiguration.baseTranslationURL,
                                                                fromLanguage: fromLanguage,
                                                                toLanguage: toLanguage)

        let translationCoordinator = TranslationCoordinator(navigationController: self.navigationController,
                                                            observationToTranslate: observation,
                                                            withConfiguration: translationConfiguration)
        translationCoordinator.start(animated: true)
        self.childCoordinators.append(translationCoordinator)
    }

    private func presentLanguages() {
        // TODO: Check if this guy lives already
        let languageSelectorCoordinator = LanguageSelectorCoordinator(languageStore: self.languageStore,
                                                                      parent: self)
        languageSelectorCoordinator.start(animated: true)
        self.childCoordinators.append(languageSelectorCoordinator)

        guard let languagesViewController = languageSelectorCoordinator.viewController else {
            return
        }

        let navigationController = UINavigationController(rootViewController: languagesViewController)
        self.navigationController.present(navigationController, animated: true, completion: nil)
    }
}

extension ObservationResultsCoordinator: ObservationResultsViewControllerDelegate {
    func observationResultsViewController(_ viewController: ObservationResultsViewController,
                                          didRequestChangingLanguageAtPosition position: LanguageSelectorHeaderView.Position) {
        self.presentLanguages()
    }

    func observationResultsViewController(_ viewController: ObservationResultsViewController,
                                          didSelectObservation observation: Observation) {
        self.presentTranslations(for: observation)
    }
}
