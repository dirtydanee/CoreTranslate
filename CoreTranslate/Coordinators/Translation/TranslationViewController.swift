//
//  TranslationViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 13.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

protocol TranslationViewControllerDelegate: class {
    func translationViewControllerDidRequestSavingTranslation(_ viewController: TranslationViewController)
}

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
    weak var delegate: TranslationViewControllerDelegate?

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
            self.enableSaveButton()
            self.removeLoadingView(animated: true)
        }
    }

    override func loadView() {
        self.typedView = TranslationView.loadFromNib()
        self.typedView.frame = UIScreen.main.bounds
        self.view = self.typedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSaveButton()
    }
}

extension TranslationViewController {
    @objc
    func didPressSaveButton(_ button: UIBarButtonItem) {
        self.delegate?.translationViewControllerDidRequestSavingTranslation(self)
    }
}

// MARK: Private API

private extension TranslationViewController {

    func setupSaveButton() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(self.didPressSaveButton(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.5
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    func enableSaveButton() {
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

    func removeLoadingView(animated: Bool) {
        let duration: TimeInterval = animated ? 0.33 : 0
        UIView.animate(withDuration: duration, animations: {
            self.loadingView.alpha = 0
        }) { _ in
            self.loadingView.removeFromSuperview()
        }
    }
}
