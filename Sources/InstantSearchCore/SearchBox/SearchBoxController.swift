//
//  SearchBoxController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 22/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Controller interfacing with a concrete query input view
public protocol SearchBoxController: AnyObject {

  /// Closure to trigger when query changed
  var onQueryChanged: ((String?) -> Void)? { get set }

  /// Closure to trigger when query submitted
  var onQuerySubmitted: ((String?) -> Void)? { get set }

  /// Update query value
  func setQuery(_ query: String?)

}

@available(*, deprecated, renamed: "SearchBoxController")
public typealias QueryInputController = SearchBoxController
