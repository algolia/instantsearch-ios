//
//  FacetListInteractor+Controller.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

extension FacetListConnector {

  public struct ControllerConnection<Controller: FacetListController>: Connection {

    public let facetListInteractor: FacetListInteractor
    public let controller: Controller
    public let presenter: SelectableListPresentable?
    public let externalReload: Bool

    public init(facetListInteractor: FacetListInteractor,
                controller: Controller,
                presenter: SelectableListPresentable? = nil,
                externalReload: Bool = false) {
      self.facetListInteractor = facetListInteractor
      self.controller = controller
      self.presenter = presenter
      self.externalReload = externalReload
    }

    public func connect() {

      ControllerConnection.setControllerItemsWith(facets: facetListInteractor.items, selections: facetListInteractor.selections, controller: controller, presenter: presenter)

      controller.onClick = { [weak facetListInteractor] facet in
        facetListInteractor?.computeSelections(selectingItemForKey: facet.value)
      }

      facetListInteractor.onItemsChanged.subscribePast(with: controller) { [weak interactor = self.facetListInteractor, presenter = self.presenter] controller, facets in
        guard let interactor = interactor else { return }
        ControllerConnection.setControllerItemsWith(facets: facets, selections: interactor.selections, controller: controller, presenter: presenter)
      }.onQueue(.main)

      facetListInteractor.onSelectionsChanged.subscribePast(with: controller) { [weak interactor = self.facetListInteractor, presenter = self.presenter] controller, selections in
        guard let interactor = interactor else { return }
        ControllerConnection.setControllerItemsWith(facets: interactor.items, selections: selections, controller: controller, presenter: presenter)
      }.onQueue(.main)

    }

    public func disconnect() {
      controller.onClick = nil
      facetListInteractor.onItemsChanged.cancelSubscription(for: controller)
      facetListInteractor.onSelectionsChanged.cancelSubscription(for: controller)
    }

    /// Add missing refinements with a count of 0 to all returned facets
    /// Example: if in result we have color: [(red, 10), (green, 5)] and that in the refinements
    /// we have "color: red" and "color: yellow", the final output would be [(red, 10), (green, 5), (yellow, 0)]
    private static func merge(_ facets: [Facet], withSelectedValues selections: Set<String>) -> [SelectableItem<Facet>] {
      return facets.map { SelectableItem<Facet>($0, selections.contains($0.value)) }
    }

    private static func setControllerItemsWith<Controller: FacetListController>(facets: [Facet], selections: Set<String>, controller: Controller, presenter: SelectableListPresentable?) {
      let updatedFacets = merge(facets, withSelectedValues: selections)
      let sortedFacetValues = presenter?.transform(refinementFacets: updatedFacets) ?? updatedFacets
      controller.setSelectableItems(selectableItems: sortedFacetValues)
      controller.reload()
    }

  }

}

public extension FacetListInteractor {

  @discardableResult func connectController<C: FacetListController>(_ controller: C,
                                                                    with presenter: SelectableListPresentable? = nil,
                                                                    externalReload: Bool = false) -> FacetListConnector.ControllerConnection<C> {

    let connection = FacetListConnector.ControllerConnection(facetListInteractor: self,
                                                    controller: controller,
                                                    presenter: presenter,
                                                    externalReload: externalReload)
    connection.connect()
    return connection
  }

}
