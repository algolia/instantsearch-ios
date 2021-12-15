//
//  FilterListInteractor+Controller.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public struct FilterListControllerConnection<Filter: FilterType & Hashable, Controller: SelectableListController>: Connection where Controller.Item == Filter {

  public let interactor: FilterListInteractor<Filter>
  public let controller: Controller

  public init(interactor: FilterListInteractor<Filter>,
              controller: Controller) {
    self.interactor = interactor
    self.controller = controller
  }

  public func connect() {

    func setControllerItemsWith(items: [Filter], selections: Set<Filter>) {
      let selectableItems = items.map { ($0, selections.contains($0)) }
      controller.setSelectableItems(selectableItems: selectableItems)
      controller.reload()
    }

    setControllerItemsWith(items: interactor.items, selections: interactor.selections)

    controller.onClick = interactor.computeSelections(selectingItemForKey:)

    interactor.onItemsChanged.subscribePast(with: controller) { [weak interactor] _, items in
      setControllerItemsWith(items: items, selections: interactor!.selections)
    }.onQueue(.main)

    interactor.onSelectionsChanged.subscribePast(with: controller) { [weak interactor] _, selections in
      setControllerItemsWith(items: interactor!.items, selections: selections)
    }.onQueue(.main)

  }

  public func disconnect() {
    interactor.onItemsChanged.cancelSubscription(for: controller)
    interactor.onSelectionsChanged.cancelSubscription(for: controller)
  }

}

public extension FilterListInteractor {

  @discardableResult func connectController<Controller: SelectableListController>(_ controller: Controller) -> FilterListControllerConnection<F, Controller> {
    let connection = FilterListControllerConnection(interactor: self, controller: controller)
    connection.connect()
    return connection
  }

}
