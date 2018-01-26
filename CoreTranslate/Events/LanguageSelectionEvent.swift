//
//  LanguageSelectionEvent.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 25.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

class LanguageSelectionEvent: Event {
    let language: Language

    init(language: Language) {
        self.language = language
    }
}
