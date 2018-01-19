//
//  UITableView+CellUsage.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 06.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {

    static var nibName: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }

    static func loadFromNib(_ owner: Any? = nil) -> Self {
        guard let objects = Bundle(for: Self.self).loadNibNamed(Self.nibName, owner: owner, options: nil) else {
            fatalError("Unable to get objects for nib name \(Self.nibName)")
        }

        for object in objects {
            if let typedSelf = object as? Self {
                return typedSelf
            }
        }
        fatalError("Unable to get objects for nib name \(Self.nibName)")
    }
}

typealias RegisterableView = ReusableView & NibLoadableView

extension UITableView {
    func register<T: UITableViewCell>(_ cell: T.Type) where T: RegisterableView {
        self.register(cell.nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }

    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UITableViewCell, T: ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("unable to queue the cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}
