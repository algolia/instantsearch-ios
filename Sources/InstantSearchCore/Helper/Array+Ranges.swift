//
//  Array+Ranges.swift
//
//
//  Created by Vladislav Fitc on 26/10/2022.
//

import Foundation

extension Array where Element: RandomAccessCollection, Element.Index == Int {
  /// Maps the nested lists to the ranges corresponding to the positions of the nested list elements in the flatten list
  /// Example: [["a", "b", "c"], ["d", "e"], ["f", "g", "h"]] -> [0..<3, 3..<5, 5..<8]
  func flatRanges() -> [Range<Int>] {
    var ranges: [Range<Int>] = []
    var offset = 0
    for sublist in self {
      let nextOffset = offset + sublist.count
      let range = offset..<nextOffset
      ranges.append(range)
      offset = nextOffset
    }
    return ranges
  }
}
