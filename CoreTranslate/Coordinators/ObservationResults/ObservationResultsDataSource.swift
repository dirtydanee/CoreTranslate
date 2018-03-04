//
//  ObservationResultsDataSource.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 06.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class ObservationResultsDataSource: NSObject, UITableViewDataSource {

    let observationStore: ObservationStore

    init(observationStore: ObservationStore) {
        self.observationStore = observationStore
    }

    func reload() {
        do {
            try self.observationStore.fetchedResultsController.performFetch()
        } catch {
            clog("Unable to reload observations. Error description: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.observationStore.objectCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ObservationResultCell = tableView.dequeueReusableCell(for: indexPath)
        let currentObservation: Observation = self.observationStore.fetch(atIndexPath: indexPath)
        let viewPresentation = ObservationViewModel(observation: currentObservation)
        cell.configure(with: viewPresentation)
        return cell
    }
}
