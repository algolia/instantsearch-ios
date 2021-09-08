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

  struct SubscriberConnection<S: AnyObject & QuerySettable> {

    public let interactor: QueryInputInteractor
    public let subscriber: S
    public let searchTriggeringMode: SearchTriggeringMode

    public init(interactor: QueryInputInteractor,
                subscriber: S,
                searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) {
      self.interactor = interactor
      self.subscriber = subscriber
      self.searchTriggeringMode = searchTriggeringMode
    }

    public func connect() {

      switch searchTriggeringMode {
      case .searchAsYouType:
        interactor.onQueryChanged.subscribe(with: subscriber) { searcher, query in
          searcher.setQuery(query)
        }

      case .searchOnSubmit:
        interactor.onQuerySubmitted.subscribe(with: subscriber) { searcher, query in
          searcher.setQuery(query)
        }
      }
    }

    public func disconnect() {

      interactor.query = nil

      switch searchTriggeringMode {
      case .searchAsYouType:
        interactor.onQueryChanged.cancelSubscription(for: subscriber)

      case .searchOnSubmit:
        interactor.onQuerySubmitted.cancelSubscription(for: subscriber)
      }

    }

  }

}

public extension QueryInputInteractor {

  @discardableResult func connect<S: AnyObject & QuerySettable>(_ subscriber: S,
                                                                searchTriggeringMode: SearchTriggeringMode = .searchAsYouType) -> SubscriberConnection<S> {
    let connection = SubscriberConnection(interactor: self, subscriber: subscriber, searchTriggeringMode: searchTriggeringMode)
    connection.connect()
    return connection
  }

}
