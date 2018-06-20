//
//  TabBarCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 21.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import CoreData

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
    let coreDataHandler: CoreDataHandler
    private(set) var childCoordinators: [Coordinator]
    let tabBarController: TabBarController
    let storeProvider: StoreProvider

    var viewController: UIViewController? {
        return self.tabBarController
    }

    private var takePhotoCoordinator: ScanCoordinator?
    private var savedTranslationCoordinator: SavedTranslationCoordinator?
    private var settingsCoordinator: SettingsCoordinator?

    init(storeProvider: StoreProvider,
         coreDataHandler: CoreDataHandler,
         parent: Coordinator) {
        self.storeProvider = storeProvider
        self.coreDataHandler = coreDataHandler
        self.parent = parent
        self.tabBarController = TabBarController()
        self.childCoordinators = []
    }

    func start(animated: Bool) {
        self.setupTakePhotoCoordinator()
        self.setupSavedTranslatedObservationCoordinator()
        self.setupSettingsCoordinator()

        let viewControllers = [self.takePhotoCoordinator?.viewController,
                               self.savedTranslationCoordinator?.viewController,
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
                                                   languageStore: self.storeProvider.languageStore,
                                                   coreDataHandler: self.coreDataHandler,
                                                   parent: self)
        takePhotoCoordinator.start(animated: false)
        takePhotoCoordinator.viewController?.view.frame = self.tabBarController.view.frame
        takePhotoCoordinator.viewController?.tabBarItem = Constants.TabBarItems.scanItem
        self.takePhotoCoordinator = takePhotoCoordinator
        self.childCoordinators.append(takePhotoCoordinator)
    }

    private func setupSavedTranslatedObservationCoordinator() {
        let savedTranslationCoordinator = SavedTranslationCoordinator(translatedObservationStore: self.storeProvider.translatedObservationStore)
        savedTranslationCoordinator.start(animated: true)
        savedTranslationCoordinator.viewController?.tabBarItem = Constants.TabBarItems.savedItem
        savedTranslationCoordinator.parent = self
        self.savedTranslationCoordinator = savedTranslationCoordinator
        self.childCoordinators.append(savedTranslationCoordinator)
    }

    private func setupSettingsCoordinator() {
        let settingsCoordinator = SettingsCoordinator(parent: self)
        settingsCoordinator.start(animated: true)
        settingsCoordinator.viewController?.tabBarItem = Constants.TabBarItems.settingsItem
        self.settingsCoordinator = settingsCoordinator
        self.childCoordinators.append(settingsCoordinator)
    }
}
