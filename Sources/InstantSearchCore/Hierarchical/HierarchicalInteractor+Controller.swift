//
//  HierarchicalInteractor+Controller.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 08/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias HierarchicalFacet = (facet: Facet, level: Int, isSelected: Bool)

public extension Hierarchical {

  struct ControllerConnection<Controller: HierarchicalController, Output>: Connection where Output == Controller.Item {

    public let interactor: HierarchicalInteractor
    public let controller: Controller
    public let presenter: ([HierarchicalFacet]) -> Output

    public func connect() {
      let presenter = self.presenter
      interactor.onItemChanged.subscribePast(with: controller) { [weak interactor] controller, facets in
        guard let interactor = interactor else { return }

        let hierarchicalFacets = facets.enumerated()
          .map { index, items in
            items.map { item in
              (item, index, interactor.selections.contains(item.value))
            }
          }.flatMap { $0 }

        controller.setItem(presenter(hierarchicalFacets))
      }.onQueue(.main)

      controller.onClick = interactor.computeSelection(key:)
    }

    public func disconnect() {
      interactor.onItemChanged.cancelSubscription(for: controller)
      controller.onClick = nil
    }

  }

}

public extension HierarchicalInteractor {

  @discardableResult func connectController<Controller: HierarchicalController, Output>(_ controller: Controller,
                                                                                        presenter: @escaping ([HierarchicalFacet]) -> Output) -> Hierarchical.ControllerConnection<Controller, Output> {
    let connection = Hierarchical.ControllerConnection(interactor: self, controller: controller, presenter: presenter)
    connection.connect()
    return connection
  }

}

public extension HierarchicalInteractor {

  @discardableResult func connectController<Controller: HierarchicalController>(_ controller: Controller,
                                                                                presenter: @escaping HierarchicalPresenter = DefaultPresenter.Hierarchical.present) -> Hierarchical.ControllerConnection<Controller, [HierarchicalFacet]> {
    let connection = Hierarchical.ControllerConnection(interactor: self, controller: controller, presenter: presenter)
    connection.connect()
    return connection
  }

}
