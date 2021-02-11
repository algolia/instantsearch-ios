//
//  ItemInteractor+Controller.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension ItemInteractor {

  struct ControllerConnection<Controller: ItemController, Output>: Connection where Controller.Item == Output {

    public let interactor: ItemInteractor
    public let controller: Controller
    public let presenter: Presenter<Item, Output>

    public func connect() {
      let presenter = self.presenter
      interactor.onItemChanged.subscribePast(with: controller) { controller, item in
        controller.setItem(presenter(item))
      }.onQueue(.main)
    }

    public func disconnect() {
      interactor.onItemChanged.cancelSubscription(for: controller)
    }

  }

}

public extension ItemInteractor {

  @discardableResult func connectController<Controller: ItemController, Output>(_ controller: Controller,
                                                                                presenter: @escaping Presenter<Item, Output>) -> ControllerConnection<Controller, Output> {
    let connection = ControllerConnection(interactor: self, controller: controller, presenter: presenter)
    connection.connect()
    return connection
  }

}
