//
//  XCTest+Int64.swift
//  InsightsTests
//
//  Created by Vladislav Fitc on 13/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
import XCTest

func XCTAssertInt64Equal(_ a: Int64, _ b: Int64, marginMS: Int64 = 50) {
    XCTAssertTrue(abs(a - b) < marginMS, "\(a) \(b)")
}
