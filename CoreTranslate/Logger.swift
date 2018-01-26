//
//  Logger.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 25.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

enum LoggingPriority: Int, CustomStringConvertible {
    case info
    case error
    case debug

    var description: String {
        switch self {
        case .info:
            return "INFO"
        case .error:
            return "ERROR"
        case .debug:
            return "DEBUG"
        }
    }

    static let current: LoggingPriority = .debug
}

func clog(_ message: String, priority: LoggingPriority = LoggingPriority.current, file: StaticString = #file, line: Int = #line) {
    if priority.rawValue >= LoggingPriority.current.rawValue {
        NSLog("[\(priority.description)][\(stripFilePath(from: file.description)):\(line)]: \(message)")
    }
}

private func stripFilePath(from file: String) -> String {
    let firstSlashIndex = file.range(of: "/", options: .backwards)!.lowerBound
    let rightPosition = file.index(firstSlashIndex, offsetBy: 1)
    return file.substring(from: rightPosition)
}
