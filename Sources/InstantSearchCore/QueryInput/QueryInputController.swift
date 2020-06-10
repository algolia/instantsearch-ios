//
//  QueryInputController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 22/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol QueryInputController: class {
  var onQueryChanged: ((String?) -> Void)? { get set }
  var onQuerySubmitted: ((String?) -> Void)? { get set }
  func setQuery(_ query: String?)
}
