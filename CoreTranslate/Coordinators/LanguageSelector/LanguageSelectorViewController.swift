//
//  LanguageSelectorViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 23.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

protocol LanguageSelectorViewControllerDelegate: class {
    func languageSelectorViewControllerDidCancel(_ languageSelectorViewController: LanguageSelectorViewController)
}

final class LanguageSelectorViewController: UIViewController {

    let dataSource: LanguageSelectorDataSource

    private var tableView: UITableView!
    private var searchController: UISearchController!
    weak var delegate: LanguageSelectorViewControllerDelegate?

    init(dataSource: LanguageSelectorDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupNavigationItem()
        self.setupSearchContoller()
        self.dataSource.reload()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }

    private func setupTableView() {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self.dataSource
        self.tableView.tableFooterView = UIView()
        self.tableView.register(LanguageCell.self)
        self.view.addSubview(self.tableView)
        self.tableView.reloadData()
    }

    private func setupNavigationItem() {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(didPressCancelButton(_:)))
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem
    }

    private func setupSearchContoller() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.searchController = searchController
        self.tableView.tableHeaderView = searchController.searchBar
        self.searchController.searchResultsUpdater = self.dataSource
    }

    @objc
    private func didPressCancelButton(_ sender: UIBarButtonItem) {
        self.delegate?.languageSelectorViewControllerDidCancel(self)
    }

    func reload() {
        self.tableView.reloadData()
    }
}
