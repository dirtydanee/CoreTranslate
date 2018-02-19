//
//  CoreDataTransformer.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.02.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

protocol CoreDataTransformer {
    var context: NSManagedObjectContext { get }
    var entityName: NSEntityDescription.CoreTranslationEntityName { get }

    var entityDescription: NSEntityDescription { get }
}

extension CoreDataTransformer {

    var entityDescription: NSEntityDescription {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: self.entityName.rawValue,
                                                                 in: self.context) else {
             fatalError("Unable to create entity description for name: \(self.entityName.rawValue)")
        }
        return entityDescription
    }
}
