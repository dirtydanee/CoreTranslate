//
//  TranslationView.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 13.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import UIKit
import StyledText
import CardsLayout

struct TranslationViewStyle {
    let titleStyle: TextStyle
    let valueStyle: TextStyle
}

final class TranslationView: UIView, NibLoadableView {

    @IBOutlet weak var translationCardsCollectionView: TranslationCardsCollectionView!
    var cardsDataSource: TranslationCardsCollectionViewDataSource?

    func present(_ viewPresentation: TranslatedObservationViewPresentation) {
        // TODO: Move dataSource from here
        self.createCardsDataSource(with: [viewPresentation])
    }

    private func createCardsDataSource(with viewPresentations: [TranslatedObservationViewPresentation]) {
        let cardsDataSource = TranslationCardsCollectionViewDataSource(viewPresentations: viewPresentations)
        self.translationCardsCollectionView.dataSource = cardsDataSource
        self.cardsDataSource = cardsDataSource
    }
}
