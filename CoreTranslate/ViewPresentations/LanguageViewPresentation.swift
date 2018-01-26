//
//  LanguageViewPresentation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 24.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

struct LanguageViewPresentation {
    let language: Language
    let languageId: String
    let flag: Language.Flag

    init(language: Language) {
        self.language = language
        self.languageId = language.humanReadable
        self.flag = language.flag.decodeEmoji
    }
}
