//
//  TranslationViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 13.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class TranslationViewController: UIViewController, DataLoading {

    typealias DataLoading = TranslatedObservationViewModel
    var state: UIViewController.State<TranslatedObservationViewModel> {
        didSet {
            self.udpate()
        }
    }

    let loadingView: LoadingView
    let errorView: UIView = UIView()

    private var typedView: TranslationView!

    init(state: UIViewController.State<TranslatedObservationViewModel>) {
        self.state = state
        self.loadingView = LoadingView(frame: UIScreen.main.bounds)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func udpate() {
        self.loadViewIfNeeded()
        switch self.state {
        case .loading:
            self.view.addSubview(self.loadingView)
        case .failed(let error):
            // TODO: Display error
            print(error)
            self.loadingView.removeFromSuperview()
        case .loaded(let viewPresentation):
            self.typedView.present(viewPresentation)
            self.typedView.translationCardsCollectionView.reloadData()
            self.removeLoadingView(animated: true)
        }
    }

    override func loadView() {
        self.typedView = TranslationView.loadFromNib()
        self.typedView.frame = UIScreen.main.bounds
        self.view = self.typedView
    }

    private func removeLoadingView(animated: Bool) {
        let duration: TimeInterval = animated ? 0.33 : 0
        UIView.animate(withDuration: duration, animations: {
            self.loadingView.alpha = 0
        }) { _ in
            self.loadingView.removeFromSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
