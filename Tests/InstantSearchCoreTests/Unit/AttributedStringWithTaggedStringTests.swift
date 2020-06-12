//
//  AttributedStringWithTaggedStringTests.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import XCTest
@testable import InstantSearchCore

class AttributedStringWithTaggedStringTests: XCTestCase {

  #if os(iOS) || os(watchOS) || os(tvOS)
  let color = UIColor.red
  #elseif os(OSX)
  let color = NSColor.red
  #endif

  private func checkRanges(string: NSAttributedString, ranges: [NSRange: [NSAttributedString.Key: Any]]) {
    string.enumerateAttributes(in: NSRange(location: 0, length: string.length), options: []) { attributes, range, _ in
      guard let expectedAttributes = ranges[range] else {
        XCTFail("Range [\(range.location), \(range.location + range.length)[ not expected")
        return
      }
      // We cannot easily compare the dictionaries because values don't necessarily conform to `Equatable`.
      // So we just verify that we have the same key set. For our purposes it's enough, because non highlighted
      // ranges will have empty attributes.
      XCTAssertEqual(Array(expectedAttributes.keys), Array(attributes.keys))
    }
  }

  func testAttributedString() {
    let input = "Woodstock is <em>Snoopy</em>'s friend"
    let highlightedString = HighlightedString(string: input)
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: color
    ]
    let attributedString = NSAttributedString(taggedString: highlightedString.taggedString, attributes: attributes)
    checkRanges(string: attributedString, ranges: [
      NSRange(location: 0, length: 13): [:],
      NSRange(location: 13, length: 6): attributes,
      NSRange(location: 19, length: 9): [:]
      ])
  }

  func testInvertedAttributedString() {
    let input = "Woodstock is <em>Snoopy</em>'s friend"
    let highlightedString = HighlightedString(string: input)
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: color
    ]
    let attributedString = NSAttributedString(taggedString: highlightedString.taggedString, inverted: true, attributes: attributes)
    checkRanges(string: attributedString, ranges: [
      NSRange(location: 0, length: 13): attributes,
      NSRange(location: 13, length: 6): [:],
      NSRange(location: 19, length: 9): attributes
    ])
  }

  func testAttributedStringList() {
    let input = ["aaa<em>bbb</em>ccc", "ddd<em>eee</em>fff"].map(HighlightedString.init).map { $0.taggedString }
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: color
    ]
    let attributedString = NSAttributedString(taggedStrings: input, separator: NSAttributedString(string: ", "), attributes: attributes)
    checkRanges(string: attributedString, ranges: [
      NSRange(location: 0, length: 3): [:],
      NSRange(location: 3, length: 3): attributes,
      NSRange(location: 6, length: 8): [:],
      NSRange(location: 14, length: 3): attributes,
      NSRange(location: 17, length: 3): [:]
    ])
  }

}
