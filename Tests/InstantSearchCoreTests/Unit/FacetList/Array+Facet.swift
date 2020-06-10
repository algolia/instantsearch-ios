//
//  Array+Facet.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 06/12/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
@testable import InstantSearchCore

extension Array where Element == Facet {

  init(prefix: String, count: Int) {
    self = (0..<count)
      .map { "\(prefix)\($0)" }
      .map { Facet(value: $0, count: .random(in: 1...100)) }
  }

}
