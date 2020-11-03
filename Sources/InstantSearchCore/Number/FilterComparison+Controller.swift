//
//  FilterComparisonConnectView.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 04/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public struct NumberInteractorControllerConnection<Controller: NumberController, Number: DoubleRepresentable>: Connection where Controller.Item == Number {

  public let interactor: NumberInteractor<Number>
  public let controller: Controller

  public func connect() {
    let computation = Computation(numeric: interactor.item) { [weak interactor] numeric in
      interactor?.computeNumber(number: numeric)
    }

    controller.setComputation(computation: computation)

    interactor.onItemChanged.subscribePast(with: controller) { controller, item in
      guard let item = item else {
        controller.invalidate()
        return
      }
      controller.setItem(item)
    }.onQueue(.main)

    interactor.onBoundsComputed.subscribePast(with: controller) { (controller, bounds) in
      controller.setBounds(bounds: bounds)
    }.onQueue(.main)

  }

  public func disconnect() {
    controller.invalidate()
    interactor.onItemChanged.cancelSubscription(for: controller)
  }

}

public extension NumberInteractor {

  @discardableResult func connectNumberController<Controller: NumberController>(_ controller: Controller) -> NumberInteractorControllerConnection<Controller, Number> where Controller.Item == Number {
    let connection = NumberInteractorControllerConnection(interactor: self, controller: controller)
    connection.connect()
    return connection
  }

}
