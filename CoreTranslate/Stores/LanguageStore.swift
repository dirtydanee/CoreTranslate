//
//  LanguageStore.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 23.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation
import CoreData

// TODO: Write tests
final class LanguageStore: NSObject, CoreDataStore {

    enum Error {
        enum Resource: Swift.Error {
            case missing
            case invalidFormat
        }
    }

    typealias Entity = Language

    let context: NSManagedObjectContext
    let entityName: String = "Language"
    let entity: NSEntityDescription
    let fetchedResultsController: NSFetchedResultsController<Language>
    let baseLanguageId: LanguageId

    init(baseLanguageId: LanguageId, context: NSManagedObjectContext) throws {
        self.baseLanguageId = baseLanguageId
        self.context = context
        try type(of: self).setupLanguages(fromResource: "Languages", with: context)

        let fetchRequest: NSFetchRequest<Language> = NSFetchRequest(entityName: self.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Language.name), ascending: true)]
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

    private static func setupLanguages(fromResource resource: String,
                                       with context: NSManagedObjectContext) throws {
        guard let languagesURL = Bundle.main.url(forResource: resource, withExtension: "plist") else {
            throw Error.Resource.missing
        }

        let languagesData = try Data(contentsOf: languagesURL)
        let languagesPlist = try PropertyListSerialization.propertyList(from: languagesData,
                                                                        options: .mutableContainers,
                                                                        format: nil)

        guard let languages = languagesPlist as? [[String: Any]] else {
            throw Error.Resource.invalidFormat
        }

        let transformer = LanguageTransformer(context: context, entityName: .language)
        try transformer.transform(languages)
    }

    // MARK: - Public interface

    func reloadAllLanguages() throws {
        self.fetchedResultsController.fetchRequest.predicate = nil
        try self.fetchedResultsController.performFetch()
    }

    @discardableResult
    func languages(containing text: String) throws -> [Language] {
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
        return try self.fetchEntities(with: predicate)
    }

    func language(with identifier: LanguageId) throws -> Language {
        let predicate = NSPredicate(format: "rawId == %@", identifier.rawValue)
        return try self.fetchEntity(with: predicate)
    }
}

extension LanguageStore: NSFetchedResultsControllerDelegate {

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
