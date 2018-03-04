//
//  AppCoordinator.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 10.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    let window: UIWindow
    let languageStore: LanguageStore
    let coreDataHandler: CoreDataHandler
    let parent: Coordinator?
    var tabBarCoordinator: TabBarCoordinator?
    private(set) var childCoordinators: [Coordinator]

    var viewController: UIViewController? {
        return nil
    }
    
    init(window: UIWindow) {
        do {
            self.window = window
            self.coreDataHandler = CoreDataHandler(modelName: "Observations")
            self.parent = nil
            self.childCoordinators = []
            let languageStore = try LanguageStore(baseLanguageId: ApplicationConfiguration.baseLanguageId,
                                                  context: self.coreDataHandler.mainContext)
            self.languageStore = languageStore
        } catch {
            clog("Unable to setup root coordinator. Error: \(error)", priority: .error)
            fatalError()
        }
    }

    func start(animated: Bool) {
        self.setupAppearance()
        let tabBarCoordinator = TabBarCoordinator(languageStore: languageStore,
                                                  context: self.coreDataHandler.mainContext,
                                                   parent: self)
        self.window.rootViewController = tabBarCoordinator.tabBarController
        self.window.makeKeyAndVisible()
        tabBarCoordinator.start(animated: false)
        self.childCoordinators.append(tabBarCoordinator)
        self.tabBarCoordinator = tabBarCoordinator
    }

    func handle(event: Event) {
        // TODO: Handle events
    }

    // TODO: Move this to some appearance class
    func setupAppearance() {
        UITabBar.appearance().tintColor = .clear
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.ct_black],
                                                         for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.ct_lightGrey],
                                                         for: .normal)
    }
}
