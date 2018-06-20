//
//  StoreProvider.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 05.03.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

final class StoreProvider {

    let coreDataHandler: CoreDataHandler
    let languageStore: LanguageStore
    let translatedObservationStore: TranslatedObservationStore

    init(coreDataHandler: CoreDataHandler) {
        do {
            self.coreDataHandler = coreDataHandler
            self.translatedObservationStore = try TranslatedObservationStore(context: coreDataHandler.saveContext)
            self.languageStore = try LanguageStore(baseLanguageId: ApplicationConfiguration.baseLanguageId,
                                                   context: self.coreDataHandler.inAppContext)
        } catch {
            clog("Unable to setup StoreProvider. Error: \(error)", priority: .error)
            fatalError()
        }
    }
}
