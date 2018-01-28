//
//  TranslationOperation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 14.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

protocol TranslationOperationDelegate: class {
    func translationOperation(_ translationOperation: TranslationOperation,
                              didFinishExecutingWithResult result: Result<TranslationResponse>)
}

final class TranslationOperation: AsyncOperation {

    let observation: Observation
    let languageSpecifier: TranslationLanguageSpecifier
    let restService: RESTService
    weak var delegate: TranslationOperationDelegate?
    private let eventQueue: DispatchQueue

    init(observation: Observation,
         languageSpecifier: TranslationLanguageSpecifier,
         restService: RESTService) {

        self.observation = observation
        self.languageSpecifier = languageSpecifier
        self.restService = restService
        self.eventQueue = DispatchQueue.global(qos: .userInteractive)
    }

    override func execute() {
        let request = RESTRequestFactory.makeTranslationRequest(for: self.observation,
                                                                fromLanguageId: self.languageSpecifier.from.id,
                                                                toLanguageId: self.languageSpecifier.to.id)
        self.restService.executeWithDecodableResponse(request: request,
                                                      completion: self.processTranslationResponse)
    }

    func processTranslationResponse(result: Result<TranslationResponse>) {
        self.eventQueue.async {
            self.delegate?.translationOperation(self,
                                                didFinishExecutingWithResult: result)
            self.finish()
        }
    }
}
