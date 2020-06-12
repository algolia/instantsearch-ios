//
//  TestSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore

class TestSearcher: Searcher {

  var query: String? {
    didSet {
      guard oldValue != query else { return }
      onQueryChanged.fire(query)
    }
  }

  var didLaunchSearch: (() -> Void)?

  var isLoading: Observer<Bool> = .init()

  var onQueryChanged: Observer<String?> = .init()

  func search() {
    didLaunchSearch?()
  }

  func cancel() {
  }

}
