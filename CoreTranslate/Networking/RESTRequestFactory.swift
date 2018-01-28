//
//  RESTRequestFactory.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 12.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

final class RESTRequestFactory {

    static func makeTranslationRequest(for observation: Observation,
                                       fromLanguageId: LanguageId,
                                       toLanguageId: LanguageId) -> RESTService.Request {

        let parameters = ["from": fromLanguageId.rawValue,
                          "to":   toLanguageId.rawValue,
                          "text": observation.identifier]
        let headers = ["Content-Type": "application/json"]
        return RESTService.Request(method: .post,
                                   path: "translate",
                                   parameters: parameters,
                                   headers: headers)
    }

}
