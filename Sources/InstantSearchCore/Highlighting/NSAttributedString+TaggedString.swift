//
//  NSAttributedString+TaggedString.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension Hit {

  /// Returns a highlighted string for a string key if highlightResult has a flat dictionary structure
  /// If the value for key is missing or it is an embedded structure, returns nil
  func hightlightedString(forKey key: String) -> HighlightedString? {
    return highlightResult?.value(forKey: key)?.value?.value
  }

}

extension NSAttributedString {

  public convenience init(taggedString: TaggedString,
                          inverted: Bool = false,
                          attributes: [NSAttributedString.Key: Any]) {
    var taggedString = taggedString
    let attributedString = NSMutableAttributedString(string: taggedString.output)
    let ranges = inverted ? taggedString.untaggedRanges : taggedString.taggedRanges
    ranges.forEach { range in
      attributedString.addAttributes(attributes, range: NSRange(range, in: taggedString.output))
    }
    self.init(attributedString: attributedString)
  }

  public convenience init(highlightedString: HighlightedString,
                          inverted: Bool = false,
                          attributes: [NSAttributedString.Key: Any]) {
    self.init(taggedString: highlightedString.taggedString, inverted: inverted, attributes: attributes)
  }

  public convenience init(highlightResult: HighlightResult,
                          inverted: Bool = false,
                          attributes: [NSAttributedString.Key: Any]) {
    self.init(taggedString: highlightResult.value.taggedString, inverted: inverted, attributes: attributes)
  }

  public convenience init(taggedStrings: [TaggedString],
                          inverted: Bool = false,
                          separator: NSAttributedString,
                          attributes: [NSAttributedString.Key: Any]) {

    let resultString = NSMutableAttributedString()

    for (idx, taggedString) in taggedStrings.enumerated() {

      let substring = NSAttributedString(taggedString: taggedString, inverted: inverted, attributes: attributes)
      resultString.append(substring)

      // No need to add separator if joined last substring
      if idx != taggedStrings.endIndex - 1 {
        resultString.append(separator)
      }
    }

    self.init(attributedString: resultString)

  }

  public convenience init(highlightedResults: [HighlightResult],
                          inverted: Bool = false,
                          separator: NSAttributedString,
                          attributes: [NSAttributedString.Key: Any]) {
    let taggedStrings = highlightedResults.map { $0.value.taggedString }
    self.init(taggedStrings: taggedStrings,
              inverted: inverted,
              separator: separator,
              attributes: attributes)
  }

}
