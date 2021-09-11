//
//  FilterState+Subscriber.swift
//  
//
//  Created by Vladislav Fitc on 13/08/2021.
//

import Foundation

public extension FilterState {

  struct SubscriberConnection<S: AnyObject & FiltersSettable>: Connection {

    public let filterState: FilterState
    public let subscriber: S

    public func connect() {
      filterState.onChange.subscribePast(with: subscriber) { searcher, filterState in
        let filters = FilterGroupConverter().sql(filterState.toFilterGroups())
        searcher.setFilters(filters)
      }
    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: subscriber)
    }

  }

  @discardableResult func connect<S: FiltersSettable>(_ subscriber: S) -> SubscriberConnection<S> {
    let connection = SubscriberConnection(filterState: self, subscriber: subscriber)
    connection.connect()
    return connection
  }

}
