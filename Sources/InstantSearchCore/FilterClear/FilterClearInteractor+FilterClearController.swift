//
//  FilterClearInteractor+FilterClearController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension FilterClearInteractor {

  struct ControllerConnection: Connection {

    public let interactor: FilterClearInteractor
    public let controller: FilterClearController

    public func connect() {
      controller.onClick = { [weak interactor] in
        interactor?.onTriggered.fire(())
      }
    }

    public func disconnect() {
      controller.onClick = .none
    }
  }

}

public extension FilterClearInteractor {

  @discardableResult func connectController(_ controller: FilterClearController) -> ControllerConnection {
    let connection = ControllerConnection(interactor: self, controller: controller)
    connection.connect()
    return connection
  }

}
