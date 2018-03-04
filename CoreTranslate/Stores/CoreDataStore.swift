//
//  CoreDataStore.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 28.02.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import CoreData

/// Unified interface for core data entity stores to generalize fetching and creation
protocol CoreDataStore {
    /// The associated type of `NSFetchRequestResult`
    associatedtype Entity: NSFetchRequestResult

    /// The managedObjectContext the store is using for fetches
    var context: NSManagedObjectContext { get }

    /// The description of the entity the store is handling
    var entity: NSEntityDescription { get }

    /// FetchedResultsController of the ContentStore
    var fetchedResultsController: NSFetchedResultsController<Entity> { get }

    /// Name of the fetchable entity
    var entityName: String { get }
}

extension CoreDataStore {

    var objectCount: Int {
       return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    /// Fetching entity with predicate
    ///
    /// - Parameter predicate: The predicate to be executed upon fetch
    /// - Returns: The entity, or `nil` if not found
    /// - Throws: Errors associated to `CoreData`
    func fetchEntity<T>(with predicate: NSPredicate?) throws -> T {
        guard let entity: T = try self.fetchEntities(with: predicate).first else {
            throw CoreDataHandler.Error.unfoundEntity
        }

        return entity
    }

    /// Fetching mulitple entities with predicate
    ///
    /// - Parameter predicate: The predicate to be executed upon fetch
    /// - Returns: The entity, or empty array if not found
    /// - Throws: Errors associated to `CoreData`
    func fetchEntities<T>(with predicate: NSPredicate?) throws -> [T] {
        self.fetchedResultsController.fetchRequest.predicate = predicate
        try self.fetchedResultsController.performFetch()
        return self.fetchedResultsController.fetchedObjects as? [T] ?? []
    }

    func fetch<T>(atIndexPath indexPath: IndexPath) -> T {
        guard let entity = self.fetchedResultsController.object(at: indexPath) as? T else {
            fatalError("Unable to fetch entity at indexPath: \(indexPath)")
        }

        return entity
    }
}
