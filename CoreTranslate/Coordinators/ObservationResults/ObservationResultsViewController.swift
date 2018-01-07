//
//  ObservationResultsViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 05.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

class ObservationResultsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewPresentations: [ObservationViewPresentation]
    let dataSource: ObservationResultsDataSource

    required init(viewPresentations: [ObservationViewPresentation]) {
        self.viewPresentations = viewPresentations
        self.dataSource = ObservationResultsDataSource(observationPresentations: viewPresentations)
        super.init(nibName: "ObservationResultsViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.navigationController?.isNavigationBarHidden = false
    }

    private func setupTableView() {
        self.tableView.dataSource = self.dataSource
        self.tableView.register(ObservationResultCell.self)
        self.tableView.reloadData()
    }
}
