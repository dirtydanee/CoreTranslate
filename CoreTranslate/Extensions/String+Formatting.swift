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
}
