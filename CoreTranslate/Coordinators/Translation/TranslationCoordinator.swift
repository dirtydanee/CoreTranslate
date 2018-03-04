//
//  TranslationCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 08.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import CoreData

struct TranslationConfiguration {
    let baseURL: URL
    let fromLanguage: Language
    let toLanguage: Language
}

final class TranslationCoordinator: Coordinator {

    let navigationController: UINavigationController
    let observation: Observation
    let configuration: TranslationConfiguration
    let coreDataHandler: CoreDataHandler
    var childCoordinators: [Coordinator]
    var parent: Coordinator?
    private let translationService: TranslationService
    private var translationViewController: TranslationViewController?

    var viewController: UIViewController? {
        return self.translationViewController
    }

    init(navigationController: UINavigationController,
         coreDataHandler: CoreDataHandler,
         observationToTranslate observation: Observation,
         withConfiguration configuration: TranslationConfiguration) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.observation = observation
        self.configuration = configuration
        self.translationService = TranslationService(baseURL: ApplicationConfiguration.baseTranslationURL)
        self.coreDataHandler = coreDataHandler
        self.translationService.delegate = self
    }

    func start(animated: Bool) {
        let translationViewController = TranslationViewController(state: .loading)
       // let navigationController = UINavigationController(rootViewController: translationViewController)
        self.navigationController.pushViewController(translationViewController, animated: animated)
        translationViewController.udpate()
        self.translationViewController = translationViewController
        self.startTranslation()
    }

    func handle(event: Event) {
        // TODO: Handle event
    }

    private func startTranslation() {
        self.translationService.translate(observation:  self.observation,
                                          fromLanguage: self.configuration.fromLanguage,
                                          toLanguage:   self.configuration.toLanguage)
    }
}

// MARK: TranslationServiceDelegate

extension TranslationCoordinator: TranslationServiceDelegate {
    func translationService(_ translationService: TranslationService,
                            didTranslateObservation translation: TranslatedObservation) {
        let viewPresentation = TranslatedObservationViewModel(translatedObservation: translation,
                                                           toTargetLanguage: self.configuration.toLanguage)
        self.translationViewController?.state = .loaded(viewPresentation)
    }

    func translationService(_ translationService: TranslationService,
                            didFailCreatingTranslationFor observation: Observation,
                            with error: Error) {
        self.translationViewController?.state = .failed(error)
    }
}

// MARK: TranslationViewControllerDelegate

extension TranslationCoordinator: TranslationViewControllerDelegate {
    func translationViewControllerDidRequestSavingTranslation(_ viewController: TranslationViewController) {
        
    }
}
