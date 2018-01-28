//
//  UIViewController+Alerts.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 14.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import UIKit

protocol AlertingView where Self: UIViewController {}
extension AlertingView {
    func presentAlert(with title: String?, message: String?, completionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        self.present(alertController, animated: true, completion: completionHandler)
    }
}

extension UIViewController {
    func addChildViewController(_ viewController: UIViewController, frame: CGRect) {
         viewController.view.frame = frame
         self.view.addSubview(viewController.view)
         viewController.didMove(toParentViewController: self)
    }

    func removeAsChildViewController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}

extension UIViewController {
    enum State<T> {
        case loading
        case failed(Error)
        case loaded(T)
    }
}

protocol DataLoading {
    associatedtype DataLoading

    var state: UIViewController.State<DataLoading> { get }
    var loadingView: LoadingView { get }
    var errorView: UIView { get }

    func udpate()
}
