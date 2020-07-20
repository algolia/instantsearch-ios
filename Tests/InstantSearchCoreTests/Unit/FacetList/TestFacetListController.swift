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

  var onClick: ((Facet) -> Void)?
  var didReload: (() -> Void)?
  var selectableItems: [(item: Facet, isSelected: Bool)] = []

  func setSelectableItems(selectableItems: [(item: Facet, isSelected: Bool)]) {
    self.selectableItems = selectableItems
  }

  func reload() {
    didReload?()
  }

}
