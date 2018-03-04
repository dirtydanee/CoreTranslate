//
//  ObservationStore.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 02.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import CoreData

final class ObservationStore: NSObject, CoreDataStore {
    typealias Entity = Observation

    let context: NSManagedObjectContext
    let entityName: String = "Observation"
    let entity: NSEntityDescription
    let fetchedResultsController: NSFetchedResultsController<Observation>

    init(context: NSManagedObjectContext) throws {
        self.context = context

        let fetchRequest: NSFetchRequest<Observation> = NSFetchRequest(entityName: self.entityName)
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

    func exists(identifier: String) -> Bool {
        do {
            let predicate = NSPredicate(format: "identifier == %@", identifier)
            let request = NSFetchRequest<Entity>(entityName: self.entityName)
            request.predicate = predicate
            let result = try self.context.fetch(request)
            print(identifier)
            print(result)
            return !result.isEmpty
        } catch {
            clog(error.localizedDescription) // TODO
            return false
        }
    }
}

extension ObservationStore: NSFetchedResultsControllerDelegate {

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
