//
//  FilterMapInteractor+Searcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 13/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//
// swiftlint:disable type_name

import Foundation
import AlgoliaSearchClient

public struct FilterMapInteractorSearcherConnection<Filter: FilterType>: Connection {

  public let interactor: SelectableSegmentInteractor<Int, Filter>
  public let searcher: HitsSearcher
  public let attribute: Attribute

  public func connect() {
    searcher.request.query.updateQueryFacets(with: attribute)
  }

  public func disconnect() {

  }

}

public extension FilterMapInteractor {

  @discardableResult func connectSearcher(_ searcher: HitsSearcher, attribute: Attribute) -> FilterMapInteractorSearcherConnection<Filter> {
    let connection = FilterMapInteractorSearcherConnection(interactor: self, searcher: searcher, attribute: attribute)
    connection.connect()
    return connection
  }

}

@available(*, deprecated, renamed: "FilterMapInteractorSearcherConnection")
public typealias SelectableFilterInteractorSearcherConnection = FilterMapInteractorSearcherConnection
