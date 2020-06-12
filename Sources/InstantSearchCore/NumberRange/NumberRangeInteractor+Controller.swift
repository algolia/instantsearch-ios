//
//  NumberRangeInteractor+Controller.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public extension NumberRange {

  struct ControllerConnection<Number: DoubleRepresentable, Controller: NumberRangeController>: Connection where Controller.Number == Number {
    public let interactor: NumberRangeInteractor<Number>
    public let controller: Controller

    public func connect() {
      interactor.onItemChanged.subscribePast(with: controller) { controller, item in
        guard let item = item else {
          controller.invalidate()
          return
        }
        controller.setItem(item)
      }.onQueue(.main)

      controller.onRangeChanged = { [weak interactor] closedRange in
        interactor?.computeNumberRange(numberRange: closedRange)
      }

      interactor.onBoundsComputed.subscribePast(with: controller) { controller, bounds in
        bounds.flatMap(controller.setBounds)
      }.onQueue(.main)
    }

    public func disconnect() {
      interactor.onItemChanged.cancelSubscription(for: controller)
      controller.onRangeChanged = nil
      interactor.onBoundsComputed.cancelSubscription(for: controller)
    }

  }

}

public extension NumberRangeInteractor {

  @discardableResult func connectController<Controller: NumberRangeController>(_ controller: Controller) ->  NumberRange.ControllerConnection<Number, Controller> {
    let connection = NumberRange.ControllerConnection(interactor: self, controller: controller)
    connection.connect()
    return connection
  }

}
