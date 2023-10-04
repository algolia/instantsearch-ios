//
//  SearchBox+Controller.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 28/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension SearchBoxInteractor {
  struct ControllerConnection<Controller: SearchBoxController>: Connection {
    /// Business logic component that handles textual query input
    public let interactor: SearchBoxInteractor

    /// Controller interfacing with a concrete query input view
    public let controller: Controller

    /// Debouncer that manages the debounce delay for successive query inputs to optimize performance.
    private let queryDebouncer: Debouncer<String?>

    /**
     - Parameters:
     - interactor: Business logic component that handles textual query input
     - controller: Controller interfacing with a concrete query input view
     - debounceInterval: The delay (in seconds) after which the query input is processed, allowing for debounced input. Default value is 100ms (0.1 seconds).
     */
    public init(interactor: SearchBoxInteractor,
                controller: Controller,
                debounceInterval: TimeInterval = 0.0001) {
      self.interactor = interactor
      self.controller = controller
      self.queryDebouncer = Debouncer(delay: debounceInterval)
    }

    public func connect() {
      interactor.onQueryChanged.subscribePast(with: controller) { controller, query in
        controller.setQuery(query)
      }.onQueue(.main)

      controller.onQueryChanged = { [weak interactor, queryDebouncer] query in
        queryDebouncer.debounce(value: query) { query in
          interactor?.query = query
        }
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

public extension SearchBoxInteractor {
  /**
   Establishes a connection with a controller
   - Parameters:
   - controller: Controller interfacing with a concrete query input view
   - Returns: Established connection
   */
  @discardableResult func connectController<Controller: SearchBoxController>(_ controller: Controller) -> ControllerConnection<Controller> {
    let connection = ControllerConnection(interactor: self,
                                          controller: controller)
    connection.connect()
    return connection
  }
}
