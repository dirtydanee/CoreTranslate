//
//  LanguageSelectorDataSource.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 23.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

protocol LanguageSelectorDataSourceDelegate: class {

    func dataSource(_ dataSource: LanguageSelectorDataSource,
                    didSelect language: Language)

    func dataSourceDidRequestReload(_ dataSource: LanguageSelectorDataSource)
}

final class LanguageSelectorDataSource: NSObject {

    let store: LanguageStore
    weak var delegate: LanguageSelectorDataSourceDelegate?

    init(store: LanguageStore) {
        self.store = store
    }

    func reload(forSearchText text: String? = nil) {
        do {
            if let text = text {
                try self.store.languages(containing: text)
            } else {
                try self.store.reloadAllLanguages()
            }
        } catch {
            clog("Unable to reload languages. Error description: \(error)")
        }
    }
}

extension LanguageSelectorDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.objectCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LanguageCell = tableView.dequeueReusableCell(for: indexPath)
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        let language: Language = self.store.fetch(atIndexPath: indexPath)
        let viewModel = LanguageViewModel(language: language)
        cell.configure(viewModel: viewModel)
        return cell
    }
}

extension LanguageSelectorDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = self.store.fetchedResultsController.object(at: indexPath)
        self.delegate?.dataSource(self, didSelect: language)
    }
}

extension LanguageSelectorDataSource: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            clog("Missing text in LanguageSelectorDataSource on UISearchController. Unable to carry out search.",
                 priority: .error)
            return
        }

        self.search(for: searchText)
    }

    private func search(for text: String) {
        defer {
            self.delegate?.dataSourceDidRequestReload(self)
        }

        if text.isEmpty {
            self.reload()
        } else {
            self.reload(forSearchText: text)
        }
    }
}
