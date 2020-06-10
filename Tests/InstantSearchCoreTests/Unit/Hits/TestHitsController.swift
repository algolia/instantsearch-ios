//
//  TestHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore

class TestHitsController<Hit: Codable>: HitsController {

  var hitsSource: HitsInteractor<Hit>?

  var didReload: (() -> Void)?
  var didScrollToTop: (() -> Void)?

  func reload() {
    didReload?()
  }

  func scrollToTop() {
    didScrollToTop?()
  }

}
