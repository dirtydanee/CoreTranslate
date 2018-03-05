//
//  NSEntityDescription+CoreTranslate.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.02.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

extension NSEntityDescription {
    enum CoreTranslationEntityName: String {
        case language = "Language"
        case observation = "Observation"
        case translatedObservation = "TranslatedObservation"
        case word = "Word"
        case translation = "Translation"
    }
}
