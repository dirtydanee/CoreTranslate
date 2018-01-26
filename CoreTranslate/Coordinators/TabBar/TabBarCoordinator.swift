//
//  TabBarCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 21.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class TabBarCoordinator: Coordinator {

    private struct Constants {
        struct TabBarItems {
            static let scanItem = UITabBarItem(title: LocalizedString("Tabbar_Scan"),
                                               image: #imageLiteral(resourceName: "tb_scan"),
                                               selectedImage: #imageLiteral(resourceName: "tb_scan_selected")) 
            static let savedItem = UITabBarItem(title: LocalizedString("Tabbar_Saved"),
                                                image: #imageLiteral(resourceName: "tb_saved"),
                                                selectedImage: #imageLiteral(resourceName: "tb_saved_selected"))
            static let settingsItem = UITabBarItem(title: LocalizedString("Tabbar_Settings"),
                                                   image: #imageLiteral(resourceName: "tb_settings"),
                                                   selectedImage: #imageLiteral(resourceName: "tb_settings_selected"))
        }
    }

    let parent: Coordinator?
    private(set) var childCoordinators: [Coordinator]
    let tabBarController: TabBarController
    let languageStore: LanguageStore

    var viewController: UIViewController? {
        return self.tabBarController
    }

    private var takePhotoCoordinator: ScanCoordinator?
    private var savedTranslatedObservationCoordinator: TranslationCoordinator? // TODO: Change it to saved
    private var settingsCoordinator: SettingsCoordinator?

    init(languageStore: LanguageStore,
         parent: Coordinator) {
        self.languageStore = languageStore
        self.parent = parent
        self.tabBarController = TabBarController()
        self.childCoordinators = []
    }

    func start(animated: Bool) {
        self.setupTakePhotoCoordinator()
        self.setupSavedTranslatedObservationCoordinator()
        self.setupSettingsCoordinator()

        let viewControllers = [self.takePhotoCoordinator?.viewController,
                               self.savedTranslatedObservationCoordinator?.viewController,
                               self.settingsCoordinator?.viewController]
                              .flatMap { $0 }
        self.tabBarController.setViewControllers(viewControllers, animated: false)
    }

    func handle(event: Event) {
        // TODO: Handle events
    }

    private func setupTakePhotoCoordinator() {
        let takePhotoNavigationController = UINavigationController()
        let takePhotoCoordinator = ScanCoordinator(navigationController: takePhotoNavigationController,
                                                        languageStore: self.languageStore,
                                                        parent: self)
        takePhotoCoordinator.start(animated: false)
        takePhotoCoordinator.viewController?.tabBarItem = Constants.TabBarItems.scanItem
        self.takePhotoCoordinator = takePhotoCoordinator
        self.childCoordinators.append(takePhotoCoordinator)
    }

    private func setupSavedTranslatedObservationCoordinator() {
        // TODO: 
//        let savedNavigationController = UINavigationController()
//        let observation = Observation(uuid: UUID(), identifier: "potato", confidence: 0.2, capturedImageData: Data())
//        let translationConfiguration = TranslationConfiguration(baseURL: ApplicationConfiguration.baseTranslationURL,
//                                                                fromLanguage: ApplicationConfiguration.baseLanguage.id,
//                                                                toLanguage: .hungarian)
//        let translationCoordinator = TranslationCoordinator(navigationController: savedNavigationController,
//                                                            observationToTranslate: observation,
//                                                            withConfiguration: translationConfiguration)
//        translationCoordinator.start(animated: true)
//        translationCoordinator.viewController?.tabBarItem = Constants.TabBarItems.savedItem
//        translationCoordinator.parent = self
//        self.savedTranslatedObservationCoordinator = translationCoordinator
//        self.childCoordinators.append(translationCoordinator)
    }

    private func setupSettingsCoordinator() {
        let settingsCoordinator = SettingsCoordinator(parent: self)
        settingsCoordinator.start(animated: true)
        settingsCoordinator.viewController?.tabBarItem = Constants.TabBarItems.settingsItem
        self.settingsCoordinator = settingsCoordinator
        self.childCoordinators.append(settingsCoordinator)
    }
}
