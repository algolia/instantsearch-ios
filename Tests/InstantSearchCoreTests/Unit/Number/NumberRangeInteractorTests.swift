//
//  NumberRangeInteractorTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 10/02/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class NumberRangeInteractorTestsTests: XCTestCase {

  func testInit() {
    _ = NumberRangeInteractor(item: Int(1)...Int(10))
    _ = NumberRangeInteractor(item: UInt(1)...UInt(10))
    _ = NumberRangeInteractor(item: Float(1)...Float(10))
    _ = NumberRangeInteractor(item: Double(1)...Double(10))
  }

}
