//
//  DynamicFacetsInteractor+Controller.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

import Foundation

public extension DynamicFacetsInteractor {

  /// Connection between a dynamic facets business logic and a controller
  struct ControllerConnection<Controller: DynamicFacetsController>: Connection {

    /// Dynamic facets business logic
    public let interactor: DynamicFacetsInteractor

    ///
    public let controller: Controller

    /**
     - parameters:
       - interactor: Dynamic facets business logic
       - controller:
     */
    public init(interactor: DynamicFacetsInteractor,
                controller: Controller) {
      self.interactor = interactor
      self.controller = controller
    }

    public func connect() {
      controller.didSelect = { [weak interactor] attribute, facet in
        guard let interactor = interactor else { return }
        interactor.toggleSelection(ofFacetValue: facet.value, for: attribute)
      }
      interactor.onSelectionsChanged.subscribePast(with: controller) { (controller, selections) in
        controller.apply(selections)
      }.onQueue(.main)

      interactor.onFacetOrderChanged.subscribePast(with: controller) { controller, facetOrder in
        controller.apply(facetOrder)
      }.onQueue(.main)
    }

    public func disconnect() {
      controller.didSelect = nil
      interactor.onSelectionsChanged.cancelSubscription(for: controller)
      interactor.onFacetOrderChanged.cancelSubscription(for: controller)
    }

  }

  @discardableResult func connectController<Controller: DynamicFacetsController>(_ controller: Controller) -> ControllerConnection<Controller> {
    let connection = ControllerConnection(interactor: self, controller: controller)
    connection.connect()
    return connection
  }

}
