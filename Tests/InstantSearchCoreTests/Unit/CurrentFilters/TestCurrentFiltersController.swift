//
//  TestCurrentFiltersController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore
import XCTest

class TestCurrentFiltersController: CurrentFiltersController {

  var items: [FilterAndID] = []

  var didReload: (() -> Void)?
  var onRemoveItem: ((FilterAndID) -> Void)?

  func setItems(_ items: [FilterAndID]) {
    self.items = items
  }

  func reload() {
    self.didReload?()
  }

}
