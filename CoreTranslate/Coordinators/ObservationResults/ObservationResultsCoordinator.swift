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
    let coreDataHandler: CoreDataHandler

    private var observationResultsViewController: ObservationResultsViewController?
    private var toLanguage: Language
    private var fromLanguage: Language

    init(navigationController: UINavigationController,
         coreDataHandler: CoreDataHandler,
         observationStore: ObservationStore,
         languageStore: LanguageStore,
         parent: Coordinator?) throws {
        self.navigationController = navigationController
        self.coreDataHandler = coreDataHandler
        self.observationStore = observationStore
        self.languageStore = languageStore
        self.parent = parent
        self.toLanguage = try languageStore.language(with: ApplicationConfiguration.preferredTargetLanguage)
        self.fromLanguage = try languageStore.language(with: ApplicationConfiguration.baseLanguageId)
        self.childCoordinators = []
    }

    func start(animated: Bool) {
        let viewController = ObservationResultsViewController(observationStore: self.observationStore)
        viewController.loadViewIfNeeded()
        viewController.updateLanguage(to: self.fromLanguage, atPosition: .from)
        viewController.updateLanguage(to: self.toLanguage, atPosition: .to)
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
        let translationConfiguration = TranslationConfiguration(baseURL: ApplicationConfiguration.baseTranslationURL,
                                                                fromLanguage: fromLanguage,
                                                                toLanguage: toLanguage)

        let translationCoordinator = TranslationCoordinator(navigationController: self.navigationController,
                                                            coreDataHandler: self.coreDataHandler,
                                                            observationToTranslate: observation,
                                                            withConfiguration: translationConfiguration)
        translationCoordinator.parent = self
        translationCoordinator.start(animated: true)
        self.childCoordinators.append(translationCoordinator)
    }

    private func presentLanguages() throws {
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
        do {
            try self.presentLanguages()
        } catch {
            clog("Unable to present languages. Error: \(error)", priority: .error)
        }

    }

    func observationResultsViewController(_ viewController: ObservationResultsViewController,
                                          didSelectObservation observation: Observation) {
        self.presentTranslations(for: observation)
    }
}
