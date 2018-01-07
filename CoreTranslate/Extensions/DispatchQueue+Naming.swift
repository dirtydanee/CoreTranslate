//
//  DispatchQueue+Naming.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 02.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation

extension StringProtocol {
    var firstLowercased: String {
        guard let first = first else { return "" }
        return String(first).lowercased() + dropFirst()
    }
}

extension DispatchQueue {

    private struct Constants {
        static let queuePrefix = "com.dirtylabs.coreTranslate."
    }

    public static func makeQueue<T>(for service: T, isConcurrent: Bool = false) -> DispatchQueue {

        let label = Constants.queuePrefix + String(describing: service).firstLowercased
        let queue: DispatchQueue
        switch isConcurrent {
        case true:
            queue = DispatchQueue(label: label, attributes: [.concurrent])
        case false:
            queue = DispatchQueue(label: label)
        }

        return queue
    }
}
