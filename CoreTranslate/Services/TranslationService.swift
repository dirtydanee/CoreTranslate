//
//  TranslationService.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 08.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

final class TranslationService {

    private let restService: RESTService
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
        self.restService = RESTService(baseURL: baseURL)
    }

    func translate(observation: Observation, from language: LanguageID, to targetLangugage: LanguageID) {
        let translationRequest = RESTRequestFactory.makeTranslationRequest(for: observation,
                                                                           fromLanguage: language,
                                                                           toLanguage: targetLangugage)
        self.restService.executeWithDecodableResponse(request: translationRequest,
                                                      completion: self.processTranslationResponse)
    }

    func processTranslationResponse(result: Result<TranslationResponse>) {

    }
}
