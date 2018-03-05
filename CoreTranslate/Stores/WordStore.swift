//
//  WordStore.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 04.03.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

class WordStore: NSObject, CoreDataStore {
    typealias Entity = Word

    let context: NSManagedObjectContext
    let entityName: String = "Word"
    let entity: NSEntityDescription
    let fetchedResultsController: NSFetchedResultsController<Word>

    init(context: NSManagedObjectContext) throws {
        self.context = context

        let fetchRequest: NSFetchRequest<Word> = NSFetchRequest(entityName: self.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Observation.confidence), ascending: true)]
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

    func fetch(byId identifier: UUID) throws -> Word {
        let predicate = NSPredicate(format: "identifier == %@", identifier as CVarArg)
        return try self.fetchEntity(with: predicate)
    }
}

extension WordStore: NSFetchedResultsControllerDelegate {

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
