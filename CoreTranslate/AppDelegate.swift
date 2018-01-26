//
//  AppDelegate.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 10.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start(animated: false)
        
        self.appCoordinator = appCoordinator
        self.window = window

        return true
    }
}
