//
//  LanguageViewPresentation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 24.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

struct LanguageViewModel {
    let language: Language
    let name: String
    let flag: Language.Flag

    init(language: Language) {
        self.language = language
        self.name = language.name
        self.flag = language.flag
    }
}
