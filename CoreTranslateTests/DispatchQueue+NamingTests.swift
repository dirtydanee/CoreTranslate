//
//  DispatchQueue+NamingTests.swift
//  CoreTranslateTests
//
//  Created by Daniel.Metzing on 02.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import XCTest
@testable import CoreTranslate

class DispatchQueue_NamingTests: XCTestCase {

    func testDefaultQueueNaming() {
        let q = DispatchQueue.makeQueue(for: CaptureDevicePermissionService.self)
        XCTAssertEqual(q.label, "com.dirtylabs.coreTranslate.captureDevicePermissionService")
    }
}
