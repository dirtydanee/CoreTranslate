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
final class LanguageStore {

    enum Error {
        enum Resource: Swift.Error {
            case missing
            case invalidFormat
        }
    }

    private let languages: [Language]
    let baseLanguageId: LanguageId
    let context: NSManagedObjectContext

    init(baseLanguageId: LanguageId, context: NSManagedObjectContext) {
        do {
            self.baseLanguageId = baseLanguageId
            self.context = context
            self.languages = try type(of: self).readLanguages(fromResource: "Languages", with: context)
        } catch let error {
            fatalError("Unable to create language store!. Error: \(error.localizedDescription)")
        }
    }

    private static func readLanguages(fromResource resource: String,
                                      with context: NSManagedObjectContext) throws -> [Language] {
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

        let transformer = LanguagesTransformer(context: context)
        return try transformer.transform(languages)
    }

    // MARK: - Public interface

    func allLanguages(ordered: Bool = true) -> [Language] {
        return ordered ? self.languages.sorted { $0.name < $1.name } : self.languages
    }

    func languages(containing text: String) -> [Language] {
        return self.languages.filter { $0.name.lowercased().contains(text) }
    }

    func language(with identifier: LanguageId) -> Language {
        guard let language = self.languages.first(where: { language in language.id == identifier }) else {
            fatalError("Language not supported!")
        }
        return language
    }
}
