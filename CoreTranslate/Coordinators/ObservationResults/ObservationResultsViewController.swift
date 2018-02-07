//
//  ObservationResultsViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 05.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

protocol ObservationResultsViewControllerDelegate: class {
    func observationResultsViewController(_ viewController: ObservationResultsViewController,
                                          didSelectObservation observation: Observation)
    func observationResultsViewController(_ viewController: ObservationResultsViewController,
                                          didRequestChangingLanguageAtPosition: LanguageSelectorHeaderView.Position)
}

class ObservationResultsViewController: UIViewController {

    private struct Layout {
        static let headerHeight: CGFloat = 50
    }

    private var tableView: UITableView!
    private var languageSelectorView: LanguageSelectorHeaderView!
    let viewPresentations: [ObservationViewPresentation]
    let dataSource: ObservationResultsDataSource
    weak var delegate: ObservationResultsViewControllerDelegate?

    init(viewPresentations: [ObservationViewPresentation]) {
        self.viewPresentations = viewPresentations
        self.dataSource = ObservationResultsDataSource(observationPresentations: viewPresentations)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupHeaderView()
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
        self.languageSelectorView.frame.size = CGSize(width: self.view.bounds.width, height: Layout.headerHeight)
    }

    // MARK: Private API

    private func setupTableView() {
        let tableView = UITableView(frame:.zero)
        tableView.dataSource = self.dataSource
        tableView.delegate = self
        tableView.register(ObservationResultCell.self)
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        self.view.addSubview(tableView)
        self.tableView = tableView
    }

    private func setupHeaderView() {
        let headerView = UITableViewHeaderFooterView(frame: CGRect(origin: .zero,
                                                                   size: CGSize(width: 0, height: Layout.headerHeight)))
        let languageSelectorView = LanguageSelectorHeaderView.loadFromNib()
        languageSelectorView.delegate = self
        headerView.addSubview(languageSelectorView)
        self.tableView.tableHeaderView = headerView
        self.languageSelectorView = languageSelectorView
    }

    // MARK: Public API

    func updateLanguage(to language: Language, atPosition position: LanguageSelectorHeaderView.Position) {
        self.languageSelectorView.setTitle(language.humanReadable, atPosition: position)
    }
}

extension ObservationResultsViewController: LanguageSelectorHeaderViewDelegate {
    func languageSelectorView(_ languageSelectorView: LanguageSelectorHeaderView,
                              didSelectLanguageAtPosition position: LanguageSelectorHeaderView.Position) {
        if position == .to {
            // TODO: Lets see what could we do here, .from is not processed ATM
            self.delegate?.observationResultsViewController(self,
                                                            didRequestChangingLanguageAtPosition: position)
        }

    }
}

extension ObservationResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedObservation = self.viewPresentations[indexPath.row].observation
        self.delegate?.observationResultsViewController(self, didSelectObservation: selectedObservation)
    }
}
