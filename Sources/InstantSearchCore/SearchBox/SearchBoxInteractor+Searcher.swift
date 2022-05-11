//
//  SearchBoxInteractor+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 13/08/2021.
//

import Foundation

public extension SearchBoxInteractor {

  struct SearcherConnection<Searcher: AnyObject & Searchable & QuerySettable>: Connection {

    /// Business logic component that handles textual query input
    public let interactor: SearchBoxInteractor

    /// Searcher that handles your searches
    public let searcher: Searcher

    /// Defines the event triggering a new search
    public let searchTriggeringMode: SearchTriggeringMode

    /**
     - Parameters:
       - interactor: Business logic that handles new search inputs
       - searcher: Searcher that handles your searches
       - searchTriggeringMode: Defines the event triggering a new search
     */
    public init(interactor: SearchBoxInteractor,
                searcher: Searcher,
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

public extension SearchBoxInteractor {

  /**
   Connects a searcher
   
   - Parameters:
     - searcher: Searcher that handles your searches
     - searchTriggeringMode: Defines the event triggering a new search
   - returns: Established connection
   */
  @discardableResult func connectSearcher<Searcher: AnyObject & Searchable & QuerySettable>(_ searcher: Searcher,
                                                                                            searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) -> SearcherConnection<Searcher> {
    let connection = SearcherConnection(interactor: self,
                                        searcher: searcher,
                                        searchTriggeringMode: searchTriggeringMode)
    connection.connect()
    return connection
  }

}
