//
//  Translation.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

struct Translation {
    struct Word {
        let value: String
        let language: LanguageID
    }

    let from: Word
    let to: Word
}
