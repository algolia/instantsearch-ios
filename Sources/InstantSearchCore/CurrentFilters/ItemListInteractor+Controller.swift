//
//  ItemListInteractor+Controller.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 19/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension ItemsListInteractor {

  struct ControllerConnection<Controller: ItemListController>: Connection where Controller.Item == Item, Item == FilterAndID {

    public let interactor: ItemsListInteractor
    public let controller: Controller
    public let presenter: Presenter<Filter, String>

    public init(interactor: ItemsListInteractor,
                controller: Controller,
                presenter: @escaping Presenter<Filter, String> = DefaultPresenter.Filter.present) {
      self.interactor = interactor
      self.controller = controller
      self.presenter = presenter
    }

    public func connect() {

      controller.onRemoveItem = { [weak interactor] item in
        let filterAndID = FilterAndID(filter: item.filter, id: item.id)
        interactor?.remove(item: filterAndID)
      }

      let presenter = self.presenter

      interactor.onItemsChanged.subscribePast(with: controller) { controller, items in
        let itemsWithPresenterApplied = items.map { FilterAndID(filter: $0.filter, id: $0.id, text: presenter($0.filter))}
        controller.setItems(itemsWithPresenterApplied)
        controller.reload()
      }.onQueue(.main)

    }

    public func disconnect() {
      controller.onRemoveItem = .none
      interactor.onItemsChanged.cancelSubscription(for: controller)
    }

  }

}

public extension ItemsListInteractor {

  @discardableResult func connectController<C: ItemListController>(_ controller: C,
                                                                   presenter: @escaping Presenter<Filter, String> = DefaultPresenter.Filter.present) -> ControllerConnection<C> where C.Item == Item, Item == FilterAndID {
    let connection = ControllerConnection(interactor: self, controller: controller, presenter: presenter)
    connection.connect()
    return connection
  }

}
