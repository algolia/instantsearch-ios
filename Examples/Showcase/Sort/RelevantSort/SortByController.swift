//
//  SortByController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 25.03.2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class SortByController: NSObject, SelectableSegmentController {

  let searchBar: UISearchBar

  var onClick: ((Int) -> Void)?

  init(searchBar: UISearchBar) {
    self.searchBar = searchBar
    super.init()
    self.searchBar.delegate = self
  }

  func setSelected(_ selected: Int?) {
    searchBar.selectedScopeButtonIndex = selected ?? 0
  }

  func setItems(items: [Int: String]) {
    searchBar.scopeButtonTitles = items.sorted(by: \.key).map(\.value)
  }

}

extension SortByController: UISearchBarDelegate {

  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    onClick?(selectedScope)
  }

}
