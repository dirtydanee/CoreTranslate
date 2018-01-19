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
    enum State<T> {
        case loading
        case failed(Error)
        case loaded(T)
    }
}

protocol DataLoading {
    associatedtype DataLoading

    var state: UIViewController.State<DataLoading> { get }
    var loadingView: UIView { get set }
    var errorView: UIView { get }

    func udpate()
}
