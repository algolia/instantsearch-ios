//
//  QueryInputInteractor+Searcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public enum SearchTriggeringMode {
  case searchAsYouType
  case searchOnSubmit
}

public extension QueryInputInteractor {

  struct SearcherConnection<S: Searcher>: Connection {

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

      interactor.query = searcher.query

      switch searchTriggeringMode {
      case .searchAsYouType:
        interactor.onQueryChanged.subscribe(with: searcher) { searcher, query in
          searcher.query = query
          searcher.search()
        }

      case .searchOnSubmit:
        interactor.onQuerySubmitted.subscribe(with: searcher) { searcher, query in
          searcher.query = query
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

  @discardableResult func connectSearcher<S: Searcher>(_ searcher: S,
                                                       searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) -> SearcherConnection<S> {
    let connection = SearcherConnection(interactor: self, searcher: searcher, searchTriggeringMode: searchTriggeringMode)
    connection.connect()
    return connection
  }

}


public extension QueryInputInteractor {

  struct BaseSearcherConnection<Service: SearchService>: Connection where Service.Process == Operation, Service.Request: TextualQueryProvider {

    public let interactor: QueryInputInteractor
    public let searcher: BaseSearcher<Service>
    public let searchTriggeringMode: SearchTriggeringMode

    public init(interactor: QueryInputInteractor,
                searcher: BaseSearcher<Service>,
                searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
      self.interactor = interactor
      self.searcher = searcher
      self.searchTriggeringMode = searchTriggeringMode
    }

    public func connect() {

      interactor.query = searcher.query

      switch searchTriggeringMode {
      case .searchAsYouType:
        interactor.onQueryChanged.subscribe(with: searcher) { searcher, query in
          searcher.request.textualQuery = query
          searcher.search()
        }

      case .searchOnSubmit:
        interactor.onQuerySubmitted.subscribe(with: searcher) { searcher, query in
          searcher.request.textualQuery = query
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

  @discardableResult func connectSearcher<Service: SearchService>(_ searcher: BaseSearcher<Service>,
                                                       searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) -> BaseSearcherConnection<Service> {
    let connection = BaseSearcherConnection(interactor: self, searcher: searcher, searchTriggeringMode: searchTriggeringMode)
    connection.connect()
    return connection
  }

}
