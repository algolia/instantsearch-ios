//
//  SelectableSegmentInteractor+Filter.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 13/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//
// swiftlint:disable type_name

import Foundation
import AlgoliaSearchClient
public struct SelectableFilterInteractorSearcherConnection<Filter: FilterType>: Connection {

  public let interactor: SelectableSegmentInteractor<Int, Filter>
  public let searcher: HitsSearcher
  public let attribute: Attribute

  public func connect() {
    searcher.indexQueryState.query.updateQueryFacets(with: attribute)
  }

  public func disconnect() {

  }

}

public extension SelectableSegmentInteractor where SegmentKey == Int, Segment: FilterType {

  @discardableResult func connectSearcher(_ searcher: HitsSearcher, attribute: Attribute) -> SelectableFilterInteractorSearcherConnection<Segment> {
    let connection = SelectableFilterInteractorSearcherConnection(interactor: self, searcher: searcher, attribute: attribute)
    connection.connect()
    return connection
  }

}
