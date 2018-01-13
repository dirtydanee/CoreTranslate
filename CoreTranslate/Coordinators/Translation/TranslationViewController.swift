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
    var state: UIView.State<TranslationViewPresentation>

    let loadingView: UIView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    let errorView: UIView = UIView()

    func udpate() {

    }

    init(state: UIView.State<TranslationViewPresentation>) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
