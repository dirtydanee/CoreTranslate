//
//  SettingsViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 22.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    var tableView: UITableView!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    private func setupTableView() {
        self.tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        self.tableView.register(SettingsTextFieldCell.self)
        self.view.addSubview(tableView)
    }
}
