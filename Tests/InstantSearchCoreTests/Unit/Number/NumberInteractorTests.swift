//
//  NumberInteractorTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 10/02/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class NumberInteractorTestsTests: XCTestCase {

  func testInit() {
    _ = NumberInteractor(item: Int(1))
    _ = NumberInteractor(item: UInt(1))
    _ = NumberInteractor(item: Float(1))
    _ = NumberInteractor(item: Double(1))
  }

}
