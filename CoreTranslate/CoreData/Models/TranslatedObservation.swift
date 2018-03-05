//
//  TranslatedObservation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 04.03.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

class TranslatedObservation: NSManagedObject {
    @NSManaged var createdAt: Date
    @NSManaged var imageData: Data
    @NSManaged var confidence: Float
    @NSManaged var translations: Set<Translation>
}
