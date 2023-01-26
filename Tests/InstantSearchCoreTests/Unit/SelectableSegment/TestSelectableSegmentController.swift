//
//  TestSelectableSegmentController.swift
//
//
//  Created by Vladislav Fitc on 14/12/2020.
//

import Foundation
@testable import InstantSearchCore

class TestSelectableSegmentController: SelectableSegmentController {
  typealias SegmentKey = Int

  var selected: Int?
  var onClick: ((Int) -> Void)?
  var items: [Int: String] = [:]

  var onSelectedChanged: (() -> Void)?
  var onItemsChanged: (() -> Void)?

  func setSelected(_ selected: Int?) {
    self.selected = selected
    onSelectedChanged?()
  }

  func setItems(items: [Int: String]) {
    self.items = items
    onItemsChanged?()
  }

  func clickItem(withKey key: Int) {
    onClick?(key)
  }
}
