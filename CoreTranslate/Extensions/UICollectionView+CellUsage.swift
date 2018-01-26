//
//  UICollectionView+CellUsage.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 20.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T>(_ cell: T.Type) where T: UICollectionViewCell & RegisterableView {
        self.register(cell.nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }

    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UICollectionViewCell & ReusableView {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("unable to queue the cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}
