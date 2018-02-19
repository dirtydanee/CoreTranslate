//
//  Observation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.02.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation
import CoreData

class Observation: NSManagedObject {

    @NSManaged var createdAt: Date
    @NSManaged var uuid: String
    @NSManaged var capturedImageData: Data
    @NSManaged var identifier: String
    @NSManaged var confidence: Float
    @NSManaged var baseLanguage: Language // TODO: Daniel - should this be a proper relationship ????

}
