//
//  Translation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation
import CoreData

struct TranslationViewModel {
    struct WordViewPresentation {
        let value: String
        let language: String
        let languageId: LanguageId
    }

    let from: WordViewPresentation
    let to: WordViewPresentation

    init(translation: Translation) {
        self.from = WordViewPresentation(value: translation.from.value,
                                         language: translation.from.language.name,
                                         languageId: translation.from.language.id)
        self.to = WordViewPresentation(value: translation.to.value,
                                       language: translation.to.language.name,
                                       languageId: translation.to.language.id)
    }
}

struct Translation {
    struct Word {
        let value: String
        let language: Language
    }

    let from: Word
    let to: Word
}
