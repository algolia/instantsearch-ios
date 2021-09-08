//
//  SwitchIndexInteractor+Searcher.swift
//  
//
//  Created by Vladislav Fitc on 08/04/2021.
//

import Foundation

public protocol IndexNameSettable {

  func setIndexName(_ indexName: IndexName)

}

public extension SwitchIndexInteractor {

  struct SubscriberConnection<Subscriber: AnyObject & IndexNameSettable>: Connection {

    public let interactor: SwitchIndexInteractor
    public let subscriber: Subscriber

    public func connect() {
      interactor.onSelectionChange.subscribe(with: subscriber) { (_, selectedIndexName) in
        subscriber.setIndexName(selectedIndexName)
      }
    }

    public func disconnect() {
      interactor.onSelectionChange.cancelSubscription(for: subscriber)
    }

  }

  @discardableResult func connect<Subscriber: AnyObject & IndexNameSettable>(_ subscriber: Subscriber) -> SubscriberConnection<Subscriber> {
    let connection = SubscriberConnection(interactor: self, subscriber: subscriber)
    connection.connect()
    return connection
  }

}
