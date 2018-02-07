//
//  LanguageHelper.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 19.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

enum LanguageId: String {
    case automatic = "auto"
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
    case estonian = "et"
    case filipino = "tl"
    case finnish = "fi"
    case french = "fr"
    case galician = "gl"
    case georgian = "ka"
    case german = "de"
    case greek = "el"
    case haitian = "ht"
    case hawaiian = "haw"
    case hebrew = "iw"
    case hindi = "hi"
    case hmong = "hmn"
    case hungarian = "hu"
    case icelandic = "is"
    case indonesian = "id"
    case irish = "ga"
    case italian = "it"
    case japanese = "ja"
    case javanese = "jw"
    case kazakh = "kk"
    case khmer = "km"
    case korean = "ko"
    case kurdish = "ku" // TODO: Add flag later
    case kyrgyz = "ky"
    case lao = "lo"
    case latin = "la"
    case latvian = "lv"
    case lithuanian = "lt"
    case luxembourgish = "lb"
    case macedonian = "mk"
    case malay = "ms"
    case malayalam = "ml"
    case maltese = "mt"
    case mongolian = "mn"
    case myanmar = "my"
    case nepali = "ne"
    case norwegian = "no"
    case polish = "pl"
    case portuguese = "pt"
    case punjabi = "ma"
    case romanian = "ro"
    case russian = "ru"
    case samoan = "sm"
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
    case thai = "th"
    case turkish = "tr"
    case ukrainian = "uk"
    case urdu = "ur"
    case uzbek = "uz"
    case vietnamese = "vi"
    case xhosa = "xh"
    case yiddish = "yi"
    case yoruba = "yo"
    case zulu = "zu"
}

struct Language {
    typealias Flag = String
    let id: LanguageId
    let flag: Flag
    let humanReadable: String
}

struct TranslationLanguageSpecifier {
    let from: Language
    let to: Language
}
