//
//  String+Formatting.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 14.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    var decodeEmoji: String {
        guard let data = self.data(using:.utf8, allowLossyConversion: true) else {
            return self
        }

        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
}
