//
//  ApplicationConfiguration.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 12.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

final class ApplicationConfiguration {
    static let baseTranslationURL: URL = URL(string: "https://server-translationapi.wedeploy.io")!
    static let baseLanguage: LanguageID = .english
}

enum LanguageID: String {
    case english = "en"
    case hungarian = "hu"
}