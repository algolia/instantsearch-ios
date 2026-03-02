//
//  TestFacetListController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 06/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore

class TestFacetListController: FacetListController {
  var onClick: ((FacetHits) -> Void)?
  var didReload: (() -> Void)?
  var selectableItems: [(item: FacetHits, isSelected: Bool)] = []

  func setSelectableItems(selectableItems: [(item: FacetHits, isSelected: Bool)]) {
    self.selectableItems = selectableItems
  }

  func reload() {
    didReload?()
  }
}
