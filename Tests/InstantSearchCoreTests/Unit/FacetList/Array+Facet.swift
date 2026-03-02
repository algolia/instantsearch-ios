//
//  Array+Facet.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 06/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore

extension Array where Element == FacetHits {
  init(prefix: String, count: Int) {
    self = (0..<count)
      .map { "\(prefix)\($0)" }
      .map { FacetHits(value: $0, highlighted: $0, count: .random(in: 1...100)) }
  }
}
