//
//  Language.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 11.02.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation
import CoreData

class Language: NSManagedObject {
    typealias Flag = String

    @NSManaged var name: String
    @NSManaged var rawId: String
    @NSManaged var flag: Flag

    var id: LanguageId {
        return LanguageId(rawValue: self.rawId) ?? .none
    }
}
