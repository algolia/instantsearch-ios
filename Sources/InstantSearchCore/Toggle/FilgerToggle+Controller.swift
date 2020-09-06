//
//  SelectableInteractor+Filter+Controller.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension FilterToggle {

  struct ControllerConnection<Filter: FilterType, Controller: SelectableController>: Connection where Controller.Item == Filter {

    public let interactor: SelectableInteractor<Filter>
    public let controller: Controller

    public init(interactor: SelectableInteractor<Filter>,
                controller: Controller) {
      self.interactor = interactor
      self.controller = controller
    }

    public func connect() {
      controller.setItem(interactor.item)
      controller.setSelected(interactor.isSelected)
      controller.onClick = interactor.computeIsSelected(selecting:)
      interactor.onSelectedChanged.subscribePast(with: controller) { controller, isSelected in
        controller.setSelected(isSelected)
      }.onQueue(.main)
      interactor.onItemChanged.subscribePast(with: controller) { controller, item in
        controller.setItem(item)
      }.onQueue(.main)
    }

    public func disconnect() {
      controller.onClick = nil
      interactor.onSelectedChanged.cancelSubscription(for: controller)
      interactor.onItemChanged.cancelSubscription(for: controller)
    }

  }

}

public extension SelectableInteractor where Item: FilterType {

  @discardableResult func connectController<Controller: SelectableController>(_ controller: Controller) -> FilterToggle.ControllerConnection<Item, Controller>  where Controller.Item == (Item) {
    let connection = FilterToggle.ControllerConnection(interactor: self, controller: controller)
    connection.connect()
    return connection
  }

}
