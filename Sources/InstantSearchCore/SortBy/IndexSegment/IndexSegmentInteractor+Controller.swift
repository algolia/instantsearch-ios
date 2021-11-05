//
//  IndexSegmentInteractor+Controller.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 06/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use SortByInteractor")
public extension IndexSegment {

  struct ControllerConnection<Controller: SelectableSegmentController>: Connection where Controller.SegmentKey == Int {

    public let interactor: IndexSegmentInteractor
    public let controller: Controller
    public let presenter: IndexPresenter

    public init(interactor: IndexSegmentInteractor,
                controller: Controller,
                presenter: @escaping IndexPresenter = DefaultPresenter.Index.present) {
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

@available(*, deprecated, message: "Use SortByInteractor")
public extension IndexSegmentInteractor {

  @discardableResult func connectController<Controller: SelectableSegmentController>(_ controller: Controller,
                                                                                     presenter: @escaping IndexPresenter = DefaultPresenter.Index.present) -> IndexSegment.ControllerConnection<Controller> where Controller.SegmentKey == SegmentKey {
    let connection = IndexSegment.ControllerConnection(interactor: self, controller: controller, presenter: presenter)
    connection.connect()
    return connection
  }

}
