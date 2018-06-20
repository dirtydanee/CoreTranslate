//
//  TranslationCardsCollectionViewDataSource.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 20.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit

final class TranslationCardsCollectionViewDataSource: NSObject {
    let viewPresentations: [TranslatedObservationViewModel]
    init(viewPresentations: [TranslatedObservationViewModel]) {
        self.viewPresentations = viewPresentations
    }
}

extension TranslationCardsCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.viewPresentations.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewPresentation = self.viewPresentations[indexPath.row]
        let cell: TranslationCard = collectionView.dequeueReusableCell(for: indexPath)
        cell.apply(style: ViewStyle.cellsStyle)
        cell.configure(with: viewPresentation)
        return cell
    }
}
