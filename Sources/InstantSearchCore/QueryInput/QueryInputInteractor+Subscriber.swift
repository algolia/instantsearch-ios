//
//  QueryInputInteractor+S.swift
//  
//
//  Created by Vladislav Fitc on 13/08/2021.
//

import Foundation

public extension QueryInputInteractor {

  struct SubscriberConnection<S: AnyObject & QuerySettable & Searchable>: Connection {

    public let interactor: QueryInputInteractor
    public let searcher: S
    public let searchTriggeringMode: SearchTriggeringMode

    public init(interactor: QueryInputInteractor,
                searcher: S,
                searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
      self.interactor = interactor
      self.searcher = searcher
      self.searchTriggeringMode = searchTriggeringMode
    }

    public func connect() {

      switch searchTriggeringMode {
      case .searchAsYouType:
        interactor.onQueryChanged.subscribe(with: searcher) { searcher, query in
          searcher.setQuery(query)
          searcher.search()
        }

      case .searchOnSubmit:
        interactor.onQuerySubmitted.subscribe(with: searcher) { searcher, query in
          searcher.setQuery(query)
          searcher.search()
        }
      }
    }

    public func disconnect() {

      interactor.query = nil

      switch searchTriggeringMode {
      case .searchAsYouType:
        interactor.onQueryChanged.cancelSubscription(for: searcher)

      case .searchOnSubmit:
        interactor.onQuerySubmitted.cancelSubscription(for: searcher)
      }

    }

  }

}

public extension QueryInputInteractor {

  @discardableResult func connect<S: AnyObject & QuerySettable>(_ searcher: S,
                                                                searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) -> SubscriberConnection<S> {
    let connection = SubscriberConnection(interactor: self, searcher: searcher, searchTriggeringMode: searchTriggeringMode)
    connection.connect()
    return connection
  }

}
