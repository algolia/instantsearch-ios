//
//  MultiIndexHitsInteractor+Controller.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 25/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexHitsInteractor {

  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  struct ControllerConnection<Controller: MultiIndexHitsController>: Connection {

    public let interactor: MultiIndexHitsInteractor
    public let controller: Controller

    public func connect() {
      controller.hitsSource = interactor

      interactor.onRequestChanged.subscribe(with: controller) { controller, _ in
        controller.scrollToTop()
      }.onQueue(.main)

      interactor.onResultsUpdated.subscribePast(with: controller) { controller, _ in
        controller.reload()
      }.onQueue(.main)

      controller.reload()
    }

    public func disconnect() {
      if controller.hitsSource === interactor {
        controller.hitsSource = nil
      }
      interactor.onRequestChanged.cancelSubscription(for: controller)
      interactor.onResultsUpdated.cancelSubscription(for: controller)
    }

  }

}

@available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
public extension MultiIndexHitsInteractor {

  @discardableResult func connectController<Controller: MultiIndexHitsController>(_ controller: Controller) -> ControllerConnection<Controller> {
    let connection = ControllerConnection(interactor: self, controller: controller)
    connection.connect()
    return connection
  }

}
