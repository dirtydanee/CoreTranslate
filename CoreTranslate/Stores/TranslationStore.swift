//
//  TranslationStore.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 05.03.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

class TranslationStore: NSObject, CoreDataStore {
    typealias Entity = Translation

    let context: NSManagedObjectContext
    let entityName: String = "Translation"
    let entity: NSEntityDescription
    let fetchedResultsController: NSFetchedResultsController<Translation>

    init(context: NSManagedObjectContext) throws {
        self.context = context

        let fetchRequest: NSFetchRequest<Translation> = NSFetchRequest(entityName: self.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Translation.fromWord.languageId),
                                                         ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: context,
                                                                   sectionNameKeyPath: nil,
                                                                   cacheName: nil)

        guard let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context) else {
            throw CoreDataHandler.Error.invalidEntityName(self.entityName)
        }
        self.entity = entity
        super.init()
        self.fetchedResultsController.delegate = self
    }

    func fetch(withFromLanguageId fromId: LanguageId, andToLanguageId toId: LanguageId) throws -> Translation {
        let predicate = NSPredicate(format: "fromWord.languageId == '%@' AND toWord.languageId == '%@'",
                                    fromId.rawValue,
                                    toId.rawValue)
        return try self.fetchEntity(with: nil)
    }
}

extension TranslationStore: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            print("insterted")
        case .delete:
            print("deleted")
        case .update:
            print("updated")
        case .move:
            print("moved")
        }
    }
}
