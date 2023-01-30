//
//  DynamicFacetListConnector+Controller.swift
//
//
//  Created by Vladislav Fitc on 17/06/2021.
//

import Foundation

public extension DynamicFacetListConnector {
  /**
   - parameters:
     - searcher: Searcher that handles your searches
     - filterState: FilterState that holds your filters
     - interactor: External dynamic facet list interactor
     - filterGroupForAttribute: Mapping between a facet attribute and a descriptor of a filter group where the corresponding facet filters stored in the filter state.
     - defaultFilterGroupType: Type of filter group created by default for a facet attribute. Default value is `and`.
     - controller: Controller presenting the ordered list of facets and handling the user interaction

    If no filter group descriptor provided, the filters for attribute will be automatically stored in the `defaultFilterGroupType` group with the facet attribute name.
   */
  convenience init<Controller: DynamicFacetListController>(searcher: Searcher,
                                                           filterState: FilterState = .init(),
                                                           interactor: DynamicFacetListInteractor = .init(),
                                                           filterGroupForAttribute: [Attribute: FilterGroupDescriptor] = [:],
                                                           defaultFilterGroupType: RefinementOperator = .and,
                                                           controller: Controller) {
    self.init(searcher: searcher,
              filterState: filterState,
              interactor: interactor,
              filterGroupForAttribute: filterGroupForAttribute,
              defaultFilterGroupType: defaultFilterGroupType)
    connectController(controller)
  }

  /**
   - parameters:
     - searcher: Searcher that handles your searches
     - filterState: FilterState that holds your filters
     - orderedFacets: Ordered list of attributed facets
     - selections: Mapping between a facet attribute and a set of selected  facet values.
     - selectionModeForAttribute: Mapping between a facet attribute and a facet values selection mode. If not provided, the default selection mode is `defaultSelectionMode`.
     - defaultSelectionMode: Selection mode to apply for a facet list. Default value is `single`.
     - filterGroupForAttribute: Mapping between a facet attribute and a descriptor of a filter group where the corresponding facet filters stored in the filter state.
     - defaultFilterGroupType: Type of filter group created by default for a facet attribute. Default value is `and`.
     - controller: Controller presenting the ordered list of facets and handling the user interaction

    If no filter group descriptor provided, the filters for attribute will be automatically stored in the `defaultFilterGroupType` group with the facet attribute name.
   */
  convenience init<Controller: DynamicFacetListController>(searcher: Searcher,
                                                           filterState: FilterState = .init(),
                                                           orderedFacets: [AttributedFacets] = [],
                                                           selections: [Attribute: Set<String>] = [:],
                                                           selectionModeForAttribute: [Attribute: SelectionMode] = [:],
                                                           defaultSelectionMode: SelectionMode = .single,
                                                           filterGroupForAttribute: [Attribute: FilterGroupDescriptor] = [:],
                                                           defaultFilterGroupType: RefinementOperator = .and,
                                                           controller: Controller) {
    let interactor = DynamicFacetListInteractor(orderedFacets: orderedFacets,
                                                selections: selections,
                                                selectionModeForAttribute: selectionModeForAttribute,
                                                defaultSelectionMode: defaultSelectionMode)
    self.init(searcher: searcher,
              filterState: filterState,
              interactor: interactor,
              filterGroupForAttribute: filterGroupForAttribute,
              defaultFilterGroupType: defaultFilterGroupType)
    connectController(controller)
  }

  /**
   Establishes a connection with a DynamicFacetListController implementation
   - parameter controller: Controller presenting the ordered list of facets and handling the user interaction
   */
  @discardableResult func connectController<Controller: DynamicFacetListController>(_ controller: Controller) -> DynamicFacetListInteractor.ControllerConnection<Controller> {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }
}
