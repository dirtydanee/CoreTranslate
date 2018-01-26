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
    private(set) var languageViewPresentations: [LanguageViewPresentation]
    weak var delegate: LanguageSelectorDataSourceDelegate?

    init(store: LanguageStore) {
        self.store = store
        self.languageViewPresentations = store.allLanguages().map { LanguageViewPresentation(language: $0) }
    }

    private func reload() {
        self.languageViewPresentations = self.store.allLanguages().map { LanguageViewPresentation(language: $0) }
    }
}

extension LanguageSelectorDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languageViewPresentations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LanguageCell = tableView.dequeueReusableCell(for: indexPath)
        let viewPresentation = self.languageViewPresentations[indexPath.row]
        cell.configure(viewPresentation: viewPresentation)
        return cell
    }
}

extension LanguageSelectorDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedViewPresentation = self.languageViewPresentations[indexPath.row]
        self.delegate?.dataSource(self, didSelect: selectedViewPresentation.language)
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
            let languages = self.store.languages(containing: text)
            self.languageViewPresentations = languages.map { LanguageViewPresentation(language: $0) }
        }
    }
}
