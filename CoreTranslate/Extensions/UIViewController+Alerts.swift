//
//  UIViewController+Alerts.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 14.12.17.
//  Copyright © 2017 Dirtylabs. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentAlert(with title: String?, message: String?, completionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        self.present(alertController, animated: true, completion: completionHandler)
    }
}
