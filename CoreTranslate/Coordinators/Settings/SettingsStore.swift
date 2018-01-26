//
//  SettingsStore.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 22.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

final class SettingsStore {

    static let shared: SettingsStore = { SettingsStore() }()
    private struct Constants {
        enum Keys: String {
            case preferredConfidance
        }
    }

    private let userDefaults: UserDefaults
    private init() {
        self.userDefaults = UserDefaults.standard
    }

    var preferredConfidance: Double {
        set {
            self.userDefaults.set(preferredConfidance, forKey: Constants.Keys.preferredConfidance.rawValue)
        }
        get {
            return self.userDefaults.double(forKey: Constants.Keys.preferredConfidance.rawValue)
        }
    }
}
