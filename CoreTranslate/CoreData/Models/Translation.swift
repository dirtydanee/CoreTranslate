//
//  Translation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 04.03.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

class Translation: NSManagedObject {
    @NSManaged var fromWord: Word
    @NSManaged var toWord: Word
    @NSManaged var isMaster: Bool
    @NSManaged var translatedObservation: TranslatedObservation
}
