//
//  SortByInteractor+Controller.swift
//  
//
//  Created by Vladislav Fitc on 27/09/2021.
//

import Foundation

public extension SortByInteractor {

  struct ControllerConnection<Controller: SelectableSegmentController>: Connection where Controller.SegmentKey == Int {

    public let interactor: SortByInteractor
    public let controller: Controller
    public let presenter: IndexNamePresenter

    public init(interactor: SortByInteractor,
                controller: Controller,
                presenter: @escaping IndexNamePresenter = DefaultPresenter.IndexName.present) {
      self.interactor = interactor
      self.controller = controller
      self.presenter = presenter
    }

    public func connect() {
      controller.setItems(items: interactor.items.mapValues(presenter))
      controller.setSelected(interactor.selected)
      controller.onClick = interactor.computeSelected(selecting:)
      interactor.onSelectedChanged.subscribePast(with: controller) { controller, selectedItem in
        controller.setSelected(selectedItem)
      }.onQueue(.main)
      interactor.onItemsChanged.subscribePast(with: controller) { controller, newItems in
        controller.setItems(items: newItems.mapValues(self.presenter))
        controller.setSelected(interactor.selected)
      }.onQueue(.main)
    }

    public func disconnect() {
      controller.setItems(items: [:])
      controller.onClick = nil
      controller.setSelected(nil)
      interactor.onSelectedChanged.cancelSubscription(for: controller)
      interactor.onItemsChanged.cancelSubscription(for: controller)
    }

  }

}

public extension SortByInteractor {

  @discardableResult func connectController<Controller: SelectableSegmentController>(_ controller: Controller,
                                                                                     presenter: @escaping IndexNamePresenter = DefaultPresenter.IndexName.present) -> ControllerConnection<Controller> where Controller.SegmentKey == Int {
    let connection = ControllerConnection(interactor: self,
                                          controller: controller,
                                          presenter: presenter)
    connection.connect()
    return connection
  }

}
