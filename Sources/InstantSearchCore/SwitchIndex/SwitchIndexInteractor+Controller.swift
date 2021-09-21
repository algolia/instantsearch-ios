//
//  SwitchIndexInteractor+Controller.swift
//  
//
//  Created by Vladislav Fitc on 08/04/2021.
//

import Foundation

public extension SwitchIndexInteractor {

  struct ControllerConnection<Controller: SwitchIndexController>: Connection {

    /// Business logic component that handles the index name switching
    public let interactor: SwitchIndexInteractor
    
    /// Controller interfacing with a concrete switch index name view
    public let controller: Controller

    public func connect() {
      controller.set(indicesNames: interactor.indicesNames, selected: interactor.selectedIndexName)

      interactor.onSelectionChange.subscribePast(with: controller) { [weak interactor]  (controller, selectedIndexName) in
        guard let interactor = interactor else { return }
        controller.set(indicesNames: interactor.indicesNames, selected: selectedIndexName)
      }.onQueue(.main)

      controller.selectIndexWithName = { [weak interactor] selectedIndexName in
        interactor?.selectedIndexName = selectedIndexName
      }
    }

    public func disconnect() {
      interactor.onSelectionChange.cancelSubscription(for: controller)
    }

  }

  /**
   Establishes a connection with a controller
   - Parameters:
     - controller: Controller interfacing with a concrete switch index view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: SwitchIndexController>(_ controller: Controller) -> SwitchIndexInteractor.ControllerConnection<Controller> {
    let connection = SwitchIndexInteractor.ControllerConnection(interactor: self,
                                                                controller: controller)
    connection.connect()
    return connection
  }

}
