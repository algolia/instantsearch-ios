//
//  SearchBoxInteractor.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Business logic component that handles textual query input
public class SearchBoxInteractor {

  /// Textual query
  public var query: String? {
    didSet {
      guard oldValue != query else { return }
      onQueryChanged.fire(query)
    }
  }

  /// Triggered when query text changed
  /// - Parameter: a new query text value
  public let onQueryChanged: Observer<String?>

  /// Triggered when query text submitted
  /// - Parameter: a submitted query text value
  public let onQuerySubmitted: Observer<String?>

  public init() {
    onQueryChanged = .init()
    onQuerySubmitted = .init()
    Telemetry.shared.trace(type: .searchBox)
  }

  public func submitQuery() {
    onQuerySubmitted.fire(query)
  }

}

@available(*, deprecated, renamed: "SearchBoxInteractor")
public typealias QueryInputInteractor = SearchBoxInteractor
