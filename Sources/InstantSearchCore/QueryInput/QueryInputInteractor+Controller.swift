//
//  QueryInputInteractor+Controller.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension QueryInputInteractor {

  struct ControllerConnection<Controller: QueryInputController>: Connection {

    public let interactor: QueryInputInteractor
    public let controller: Controller

    public func connect() {

      interactor.onQueryChanged.subscribePast(with: controller) { controller, query in
        controller.setQuery(query)
      }.onQueue(.main)

      controller.onQueryChanged = { [weak interactor] in
        interactor?.query = $0
      }

      controller.onQuerySubmitted = { [weak interactor] in
        interactor?.query = $0
        interactor?.submitQuery()
      }

    }

    public func disconnect() {
      interactor.onQueryChanged.cancelSubscription(for: controller)
      controller.onQueryChanged = nil
      controller.onQuerySubmitted = nil
    }

  }

}

public extension QueryInputInteractor {

  @discardableResult func connectController<Controller: QueryInputController>(_ controller: Controller) -> ControllerConnection<Controller> {
    let connection = ControllerConnection(interactor: self, controller: controller)
    connection.connect()
    return connection
  }

}
