//
//  TestSearchBoxController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore

class TestSearchBoxController: SearchBoxController {

  var query: String? {
    didSet {
      guard oldValue != query else { return }
      onQueryChanged?(query)
    }
  }

  var onQueryChanged: ((String?) -> Void)?
  var onQuerySubmitted: ((String?) -> Void)?

  func setQuery(_ query: String?) {
    self.query = query
  }

  func submitQuery() {
    onQuerySubmitted?(query)
  }

}
