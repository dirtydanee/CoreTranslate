//
//  TranslationViewPresentation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 13.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

struct TranslationViewPresentation {
    let originalText: String
    let translatedText: String
    let fromLanguage: String
    let toLanguage: String
    let image: UIImage?
    let translatedObservation: TranslatedObservation

    init(translatedObservation: TranslatedObservation, toLanguage: LanguageID) {
        self.translatedObservation = translatedObservation
        self.originalText = translatedObservation.observation.identifier
        self.translatedText = translatedObservation.translations.first(where: {
            $0.to.language == toLanguage })?
            .to.value ?? ""

        self.fromLanguage = translatedObservation.translations.first(where: {
            $0.to.language == toLanguage })?
            .from.value ?? ""
        
        self.toLanguage = toLanguage.humanReadable
        self.image = UIImage(data: translatedObservation.observation.capturedImageData)
    }
}
