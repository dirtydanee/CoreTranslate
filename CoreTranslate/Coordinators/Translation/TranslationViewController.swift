//
//  TranslationViewController.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 13.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class TranslationViewController: UIViewController, DataLoading {

    typealias DataLoading = TranslationViewPresentation
    var state: UIViewController.State<TranslationViewPresentation> {
        didSet {
            self.udpate()
        }
    }

    var loadingView: UIView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualView = UIVisualEffectView(effect: blurEffect)
        visualView.frame = UIScreen.main.bounds
        visualView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.center = visualView.center
        visualView.contentView.addSubview(activityIndicator)
        return visualView
    }()

    let errorView: UIView = UIView()
    private var typedView: TranslationView!
    private var effectView: UIVisualEffectView?

    init(state: UIViewController.State<TranslationViewPresentation>) {
        self.state = state
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
            self.loadingView.removeFromSuperview()
        }
    }

    override func loadView() {
        self.typedView = TranslationView.loadFromNib()
        self.typedView.frame = UIScreen.main.bounds
        self.view = self.typedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
