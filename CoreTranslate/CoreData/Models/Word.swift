//
//  Word.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 04.03.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

class Word: NSManagedObject {
    @NSManaged var identifier: UUID
    @NSManaged var languageId: String
    @NSManaged var value: String
    @NSManaged var translation: Translation
}
