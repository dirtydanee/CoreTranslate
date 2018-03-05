//
//  TranslatedObservationStore.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 04.03.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

class TranslatedObservationStore: NSObject, CoreDataStore {
    typealias Entity = TranslatedObservation

    let context: NSManagedObjectContext
    let entityName: String = "TranslatedObservation"
    let entity: NSEntityDescription
    let fetchedResultsController: NSFetchedResultsController<TranslatedObservation>

    init(context: NSManagedObjectContext) throws {
        self.context = context

        let fetchRequest: NSFetchRequest<TranslatedObservation> = NSFetchRequest(entityName: self.entityName)
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
}

extension TranslatedObservationStore: NSFetchedResultsControllerDelegate {

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
