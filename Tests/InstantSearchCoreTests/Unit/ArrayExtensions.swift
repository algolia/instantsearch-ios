//
//  ArrayExtensionsTests.swift
//
//
//  Created by Vladislav Fitc on 26/10/2022.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class ArrayExtensionsTests: XCTestCase {
  func testFlatRanges() {
    let input = [["a", "b", "c"], ["d", "e"], ["f", "g", "h"]]
    let output = [0..<3, 3..<5, 5..<8]
    XCTAssertEqual(input.flatRanges(), output)

    XCTAssertEqual([["a"], ["b"], ["c"]].flatRanges(), [0..<1, 1..<2, 2..<3])
    XCTAssertEqual([["a"], ["b"], []].flatRanges(), [0..<1, 1..<2, 2..<2])
    XCTAssertEqual([["a"], [], ["c"]].flatRanges(), [0..<1, 1..<1, 1..<2])
    XCTAssertEqual([[], [], []].flatRanges(), [0..<0, 0..<0, 0..<0])
    XCTAssertEqual([["a", "b"], ["c"], ["d"]].flatRanges(), [0..<2, 2..<3, 3..<4])
    XCTAssertEqual([[String]]().flatRanges(), [])

    print(["a", "b", "c"][3..<3])
  }
}
