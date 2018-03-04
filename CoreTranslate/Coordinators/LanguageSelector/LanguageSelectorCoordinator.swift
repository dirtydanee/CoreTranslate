//
//  LanguageSelectorCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 23.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class LanguageSelectorCoordinator: Coordinator {

    var viewController: UIViewController? {
        return self.languageViewController
    }

    let parent: Coordinator?
    private(set) var childCoordinators: [Coordinator]

    let languageStore: LanguageStore
    private var languageViewController: LanguageSelectorViewController!

    init(languageStore: LanguageStore,
         parent: Coordinator?) {
        self.languageStore = languageStore
        self.parent = parent
        self.childCoordinators = []
    }

    func start(animated: Bool) {
        let dataSource = LanguageSelectorDataSource(store: self.languageStore)
        dataSource.delegate = self
        self.languageViewController = LanguageSelectorViewController(dataSource: dataSource)
        self.languageViewController.delegate = self
    }

    func handle(event: Event) {
        // TODO: Handle events
    }
}

extension LanguageSelectorCoordinator: LanguageSelectorViewControllerDelegate {
    func languageSelectorViewControllerDidCancel(_ languageSelectorViewController: LanguageSelectorViewController) {
        self.languageViewController.dismiss(animated: true, completion: nil)
    }
}

extension LanguageSelectorCoordinator: LanguageSelectorDataSourceDelegate {
    func dataSource(_ dataSource: LanguageSelectorDataSource, didSelect language: Language) {
        let languageSelectionEvent = LanguageSelectionEvent(language: language)
        self.parent?.handle(event: languageSelectionEvent)
        self.languageViewController.dismiss(animated: true, completion: nil)
    }

    func dataSourceDidRequestReload(_ dataSource: LanguageSelectorDataSource) {
        self.languageViewController.reload()
    }
}
