//
//  SwitchIndexInteractor+Controller.swift
//  
//
//  Created by Vladislav Fitc on 08/04/2021.
//

import Foundation

public protocol SwitchIndexController: class {
  
  var select: (IndexName) -> Void { get set }
  
  func set(indexNames: [IndexName], selected: IndexName)
  
}

public extension SwitchIndexInteractor {
  
  struct ControllerConnection<Controller: SwitchIndexController>: Connection {

    public let interactor: SwitchIndexInteractor
    public let controller: Controller

    public func connect() {
      controller.set(indexNames: interactor.indexNames, selected: interactor.selectedIndexName)

      interactor.onSelectionChange.subscribePast(with: controller) { [weak interactor]  (controller, selectedIndexName) in
        guard let interactor = interactor else { return }
        controller.set(indexNames: interactor.indexNames, selected: selectedIndexName)
      }.onQueue(.main)
      
      controller.select = { [weak interactor] selectedIndexName in
        interactor?.selectedIndexName = selectedIndexName
      }
    }

    public func disconnect() {
      interactor.onSelectionChange.cancelSubscription(for: controller)
    }

  }
  
  @discardableResult func connectController<Controller: SwitchIndexController>(_ controller: Controller) -> SwitchIndexInteractor.ControllerConnection<Controller> {
    let connection = SwitchIndexInteractor.ControllerConnection<Controller>(interactor: self, controller: controller)
    connection.connect()
    return connection
  }
  
}
