//
//  QueryInputInteractor+TextualQuerySearcher.swift
//  
//
//  Created by Vladislav Fitc on 22/12/2020.
//

import Foundation

public extension QueryInputInteractor {

  struct TextualQuerySearcherConnection<Service: SearchService>: Connection where Service.Process == Operation, Service.Request: TextualQueryProvider {

    public let interactor: QueryInputInteractor
    public let searcher: AbstractSearcher<Service>
    public let searchTriggeringMode: SearchTriggeringMode

    public init(interactor: QueryInputInteractor,
                searcher: AbstractSearcher<Service>,
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

  @discardableResult func connectSearcher<Service: SearchService>(_ searcher: AbstractSearcher<Service>,
                                                                  searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) -> TextualQuerySearcherConnection<Service> {
    let connection = TextualQuerySearcherConnection(interactor: self, searcher: searcher, searchTriggeringMode: searchTriggeringMode)
    connection.connect()
    return connection
  }

}
