//
//  QueryInputInteractor+S.swift
//  
//
//  Created by Vladislav Fitc on 13/08/2021.
//

import Foundation

public protocol QuerySettable {
  
  func setQuery(_ query: String?)
  
}

public extension QueryInputInteractor {
  
  struct RecieverConnection<S: AnyObject & QuerySettable> {
    
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
        }

      case .searchOnSubmit:
        interactor.onQuerySubmitted.subscribe(with: searcher) { searcher, query in
          searcher.setQuery(query)
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

  @discardableResult func connectSearcherS<S: AnyObject & QuerySettable>(_ searcher: S,
                                                                  searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) -> RecieverConnection<S> {
    let connection = RecieverConnection(interactor: self, searcher: searcher, searchTriggeringMode: searchTriggeringMode)
    connection.connect()
    return connection
  }

}
