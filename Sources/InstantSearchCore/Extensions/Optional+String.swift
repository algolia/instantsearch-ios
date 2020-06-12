//
//  Optional+String.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 13/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {

  var isNilOrEmpty: Bool {
    switch self {
    case .some(let string):
      return string.isEmpty
    case .none:
      return true
    }
  }

}
