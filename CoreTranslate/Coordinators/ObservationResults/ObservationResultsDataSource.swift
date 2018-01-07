//
//  ObservationResultsDataSource.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 06.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class ObservationResultsDataSource: NSObject, UITableViewDataSource {

    let observationPresentations: [ObservationViewPresentation]

    init(observationPresentations: [ObservationViewPresentation]) {
        self.observationPresentations = observationPresentations
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.observationPresentations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ObservationResultCell = tableView.dequeueReusableCell(for: indexPath)
        let viewPresentation = observationPresentations[indexPath.row]
        cell.configure(with: viewPresentation)
        return cell
    }
}
