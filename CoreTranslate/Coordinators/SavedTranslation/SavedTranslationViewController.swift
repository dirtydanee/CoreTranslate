//
//  SavedTranslationViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 05.03.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class SavedTranslationViewControllerDataSource: NSObject, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Daniel - continue from here
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Daniel - continue from here
        return UITableViewCell()
    }
}

final class SavedTranslationViewController: UIViewController {

    private var typedView: TranslationView!

    init(dataSource: SavedTranslationViewControllerDataSource) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.typedView = TranslationView.loadFromNib()
        self.typedView.frame = UIScreen.main.bounds
        self.view = self.typedView
    }

}
