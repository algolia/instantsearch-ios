//
//  DynamicFacetListInteractor+Controller.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

import Foundation

public extension DynamicFacetListInteractor {

  /// Connection between a dynamic facet list business logic and a controller
  struct ControllerConnection<Controller: DynamicFacetListController>: Connection {

    /// Dynamic facet list business logic
    public let interactor: DynamicFacetListInteractor

    /// Controller presenting the ordered list of facets and handling user interaction
    public let controller: Controller

    /**
     - parameters:
       - interactor: Dynamic facets business logic
       - controller: Controller presenting the ordered list of facets and handling the user interaction
     */
    public init(interactor: DynamicFacetListInteractor,
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
        controller.setSelections(selections)
      }.onQueue(.main)

      interactor.onFacetOrderChanged.subscribePast(with: controller) { controller, orderedFacets in
        controller.setOrderedFacets(orderedFacets)
      }.onQueue(.main)
    }

    public func disconnect() {
      controller.didSelect = nil
      interactor.onSelectionsChanged.cancelSubscription(for: controller)
      interactor.onFacetOrderChanged.cancelSubscription(for: controller)
    }

  }

  /**
   Establishes a connection with a DynamicFacetListController implementation
   - parameter controller: Controller presenting the ordered list of facets and handling the user interaction
   */
  @discardableResult func connectController<Controller: DynamicFacetListController>(_ controller: Controller) -> ControllerConnection<Controller> {
    let connection = ControllerConnection(interactor: self, controller: controller)
    connection.connect()
    return connection
  }

}
