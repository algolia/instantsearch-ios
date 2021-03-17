//
//  DynamicFacetsInteractor+Controller.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

import Foundation

public protocol DynamicFacetsController: class {
  
  func apply(_ facetOrder: [AttributedFacets])
  func apply(_ selections: [Attribute: Set<String>])
  
  var didSelect: ((Attribute, Facet) -> Void)? { get set }
  
}

public extension DynamicFacetsInteractor {
  
  struct ControllerConnection<Controller: DynamicFacetsController>: Connection {
    
    public let interactor: DynamicFacetsInteractor
    public let controller: Controller
    
    public init(interactor: DynamicFacetsInteractor, controller: Controller) {
      self.interactor = interactor
      self.controller = controller
    }
    
    public func connect() {
      controller.didSelect = { [weak interactor] attribute, facet in
        guard let interactor = interactor else { return }
        interactor.toggleSelection(ofFacetValue: facet.value, for: attribute)
      }
      interactor.onSelectionsUpdated.subscribePast(with: controller) { (controller, selections) in
        controller.apply(selections)
      }.onQueue(.main)
      interactor.onFacetOrderUpdated.subscribePast(with: controller) { controller, facetOrder in
        controller.apply(facetOrder.facetOrder)
      }.onQueue(.main)
    }
    
    public func disconnect() {
      controller.didSelect = nil
      interactor.onSelectionsUpdated.cancelSubscription(for: controller)
      interactor.onFacetOrderUpdated.cancelSubscription(for: controller)
    }
    
  }
  
  @discardableResult func connectController<Controller: DynamicFacetsController>(_ controller: Controller) -> ControllerConnection<Controller> {
    let connection = ControllerConnection(interactor: self, controller: controller)
    connection.connect()
    return connection
  }
  
}
