//
//  Optional+Collection.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 12/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

extension Optional where Wrapped: Collection {
  var isNilOrEmpty: Bool {
    switch self {
    case .none:
      return true
    case let .some(collection):
      return collection.isEmpty
    }
  }
}
