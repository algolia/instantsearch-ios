//
//  SwitchIndexInteractor+Controller.swift
//
//
//  Created by Vladislav Fitc on 08/04/2021.
//
import Foundation

@available(*, deprecated, message: "Use SortByInteractor with SelectableSegmentController instead")
public protocol SwitchIndexController: AnyObject {

  /// Closure to trigger when an index selected
  var select: (IndexName) -> Void { get set }

  /// External update of the indices names list and the currently selected index name
  func set(indexNames: [IndexName], selected: IndexName)

}

@available(*, deprecated, message: "Use SortByInteractor instead")
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
