//
//  Translation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

struct TranslationViewModel {
    struct WordViewModel {
        let value: String
        let language: String
    }

    let from: WordViewModel
    let to: WordViewModel

    init(fromWord: Word,
         fromLanguage: String,
         toWord: Word,
         toLanguage: String) {
        self.from = WordViewModel(value: fromWord.value,
                                  language: fromLanguage)
        self.to = WordViewModel(value: toWord.value,
                                language: toLanguage)
    }
}
