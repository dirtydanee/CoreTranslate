//
//  TranslationCardsCollectionView.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import CardsLayout

final class TranslationCardsCollectionView: UICollectionView {

    let cardsCollectionViewLayout: CardsCollectionViewLayout

    required init?(coder aDecoder: NSCoder) {
        self.cardsCollectionViewLayout = CardsCollectionViewLayout()
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        self.setupCollectionView()
    }

    private func setupCollectionView() {
        // CollectionView
        self.collectionViewLayout = self.cardsCollectionViewLayout
        self.backgroundColor = .ct_mediumGrey
        self.register(TranslationCard.self)
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false

        // Layout
        // TODO: Remove hard coded height
        self.cardsCollectionViewLayout.itemSize = CGSize(width: 300, height: 530)
    }
}
