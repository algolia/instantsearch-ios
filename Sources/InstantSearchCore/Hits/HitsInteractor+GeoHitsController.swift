//
//  HitsInteractor+GeoHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/10/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension HitsInteractor where Record: Geolocated {

  struct GeoHitsControllerConnection<Controller: GeoHitsController>: Connection where Controller.DataSource == HitsInteractor {

    let interactor: HitsInteractor
    let controller: Controller

    public func connect() {
      controller.hitsSource = interactor
      interactor.onResultsUpdated.subscribePast(with: controller) { (controller, _) in
        controller.reload()
      }.onQueue(.main)
    }

    public func disconnect() {
      if controller.hitsSource === interactor {
        controller.hitsSource = nil
      }
      interactor.onResultsUpdated.cancelSubscription(for: controller)
    }

  }

}

public extension HitsInteractor where Record: Geolocated {

  @discardableResult func connectController<Controller: GeoHitsController>(_ controller: Controller) -> HitsInteractor<Record>.GeoHitsControllerConnection<Controller> where Controller.DataSource == HitsInteractor<Record> {
    let connection = GeoHitsControllerConnection(interactor: self, controller: controller)
    connection.connect()
    return connection
  }

}
