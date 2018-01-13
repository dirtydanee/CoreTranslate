//
//  TranslationCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 08.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

struct TranslationConfiguration {
    let baseTranslationURL: URL
    let fromLanguage: LanguageID
    let toLanguage: LanguageID
}

final class TranslationCoordinator: Coordinator {

    let navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    let observation: Observation
    let configuration: TranslationConfiguration
    private let translationService: TranslationService
    private var translationViewController: TranslationViewController?

    init(navigationController: UINavigationController,
         observationToTranslate observation: Observation,
         withConfiguration configuration: TranslationConfiguration) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.observation = observation
        self.configuration = configuration
        self.translationService = TranslationService(baseURL: ApplicationConfiguration.baseTranslationURL)
    }

    func start(animated: Bool) {
        // TODO: Daniel Push in viewcontroller
        self.startTranslation()
        let translationViewController = TranslationViewController(state: .loading)

    }

    private func startTranslation() {
        self.translationService.translate(observation: self.observation,
                                          from: self.configuration.fromLanguage,
                                          to: self.configuration.toLanguage)
    }
}
