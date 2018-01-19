//
//  TranslationResponse.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 12.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

//{
//    response =     {
//        from =         {
//            language =             {
//                didYouMean = 0;
//                iso = en;
//            };
//            text =             {
//                autoCorrected = 0;
//                didYouMean = 0;
//                value = "";
//            };
//        };
//        raw = "";
//        text = "rol\U00f3";
//    };
//}

struct TranslationResponse: Codable {
    let text: String
}
