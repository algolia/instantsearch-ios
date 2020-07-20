//
//  QueryInputInteractor.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class QueryInputInteractor {

  public var query: String? {
    didSet {
      guard oldValue != query else { return }
      onQueryChanged.fire(query)
    }
  }

  public let onQueryChanged: Observer<String?>
  public let onQuerySubmitted: Observer<String?>

  public init() {
    onQueryChanged = .init()
    onQuerySubmitted = .init()
  }

  public func submitQuery() {
    onQuerySubmitted.fire(query)
  }

}
