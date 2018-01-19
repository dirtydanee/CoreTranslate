//
//  TranslatedObservation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

struct TranslatedObservation {
    let observation: Observation
    var translations: [Translation]

    mutating func add(_ translation: Translation) {
        self.translations.append(translation)
    }
}
