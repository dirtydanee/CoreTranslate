//
//  LanguageHelper.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

enum LanguageID: String {
    case automatic = "auto"
    case afrikaans = "af"
    case albanian = "sq"
    case amharic = "am"
    case arabic = "ar"
    case armenian = "hy"
    case azerbaijani = "az"
    case basque = "eu"
    case belarusian = "be"
    case bengali = "bn"
    case bosnian = "bs"
    case bulgarian = "bg"
    case catalan = "ca"
    case cebuano = "ceb"
    case chichewa = "ny"
    case chineseSimplified = "zh-cn"
    case chineseTraditional = "zh-tw"
    case corsican = "co"
    case croatian = "hr"
    case czech = "cs"
    case danish = "da"
    case dutch = "nl"
    case english = "en"
    case esperanto = "eo"
    case estonian = "et"
    case filipino = "tl"
    case finnish = "fi"
    case french = "fr"
    case frisian = "fy"
    case galician = "gl"
    case georgian = "ka"
    case german = "de"
    case greek = "el"
    case gujarati = "gu"
    case haitian = "ht"
    case hausa = "ha"
    case hawaiian = "haw"
    case hebrew = "iw"
    case hindi = "hi"
    case hmong = "hmn"
    case hungarian = "hu"
    case icelandic = "is"
    case igbo = "ig"
    case indonesian = "id"
    case irish = "ga"
    case italian = "it"
    case japanese = "ja"
    case javanese = "jw"
    case kannada = "kn"
    case kazakh = "kk"
    case khmer = "km"
    case korean = "ko"
    case kurdish = "ku"
    case kyrgyz = "ky"
    case lao = "lo"
    case latin = "la"
    case latvian = "lv"
    case lithuanian = "lt"
    case luxembourgish = "lb"
    case macedonian = "mk"
    case malagasy = "mg"
    case malay = "ms"
    case malayalam = "ml"
    case maltese = "mt"
    case maori = "mi"
    case marathi = "mr"
    case mongolian = "mn"
    case myanmar = "my"
    case nepali = "ne"
    case norwegian = "no"
    case pashto = "ps"
    case persian = "fa"
    case polish = "pl"
    case portuguese = "pt"
    case punjabi = "ma"
    case romanian = "ro"
    case russian = "ru"
    case samoan = "sm"
    case scots = "gd"
    case serbian = "sr"
    case sesotho = "st"
    case shona = "sn"
    case sindhi = "sd"
    case sinhala = "si"
    case slovak = "sk"
    case slovenian = "sl"
    case somali = "so"
    case spanish = "es"
    case sundanese = "su"
    case swahili = "sw"
    case swedish = "sv"
    case tajik = "tg"
    case tamil = "ta"
    case telugu = "te"
    case thai = "th"
    case turkish = "tr"
    case ukrainian = "uk"
    case urdu = "ur"
    case uzbek = "uz"
    case vietnamese = "vi"
    case welsh = "cy"
    case xhosa = "xh"
    case yiddish = "yi"
    case yoruba = "yo"
    case zulu = "zu"

    var humanReadable: String {
        switch self {
        case .chineseSimplified:
            return "Chinese Simplified"
        case .chineseTraditional:
            return "Chinese Traditional"
        default:
            return self.rawValue.capitalizingFirstLetter()
        }
    }
}

struct TranslationLanguageSpecifier {
    let from: LanguageID
    let to: LanguageID
}
