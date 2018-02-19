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
    @NSManaged var name: String
    @NSManaged var rawId: String
    @NSManaged var flag: Flag
}
