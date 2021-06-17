//
//  DynamicFacetsConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/06/2021.
//

import Foundation

public extension DynamicFacetsConnector {
  
  /**
  - parameters:
    - searcher: Searcher that handles your searches
    - filterState: FilterState that holds your filters
    - interactor: External dynamic facets interactor
    - filterGroupForAttribute: Mapping between a facet attribute and a descriptor of a filter group where the corresponding facet filters stored in the filter state.
    - controller: DynamicFacetsController implementation to connect
   
   If no filter group descriptor provided, the filters for attribute will be automatically stroed in the conjunctive (`and`)  group with the facet attribute name.
  */
  convenience init<Controller: DynamicFacetsController>(searcher: Searcher,
                                                        filterState: FilterState = .init(),
                                                        interactor: DynamicFacetsInteractor = .init(),
                                                        filterGroupForAttribute: [Attribute: FilterGroupDescriptor] = [:],
                                                        controller: Controller) {
    self.init(searcher: searcher,
              filterState: filterState,
              interactor: interactor,
              filterGroupForAttribute: filterGroupForAttribute)
    connectController(controller)
  }
  
  /**
  - parameters:
    - searcher: Searcher that handles your searches
    - filterState: FilterState that holds your filters
    - orderedFacets: Ordered list of attributed facets
    - selections: Mapping between a facet attribute and a set of selected  facet values
    - selectionModeForAttribute: Mapping between a facet attribute and a facet values selection mode. If not provided, the default selection mode is .single.
    - filterGroupForAttribute: Mapping between a facet attribute and a descriptor of a filter group where the corresponding facet filters stored in the filter state.
    - controller: DynamicFacetsController implementation to connect
   
  If no filter group descriptor provided, the filters for attribute will be automatically stroed in the conjunctive (`and`)  group with the facet attribute name.
  */
  convenience init<Controller: DynamicFacetsController>(searcher: Searcher,
                                                        filterState: FilterState = .init(),
                                                        orderedFacets: [AttributedFacets] = [],
                                                        selections: [Attribute: Set<String>] = [:],
                                                        selectionModeForAttribute: [Attribute: SelectionMode] = [:],
                                                        filterGroupForAttribute: [Attribute: FilterGroupDescriptor] = [:],
                                                        controller: Controller) {
    let interactor = DynamicFacetsInteractor(orderedFacets: orderedFacets,
                                             selections: selections,
                                             selectionModeForAttribute: selectionModeForAttribute)
    self.init(searcher: searcher,
              filterState: filterState,
              interactor: interactor,
              filterGroupForAttribute: filterGroupForAttribute)
    connectController(controller)
  }
  
  /**
   Establishes a connection with a DynamicFacetsController implementation
   - parameter controller: DynamicFacetsController implementation to connect
   */
  @discardableResult func connectController<Controller: DynamicFacetsController>(_ controller: Controller) -> DynamicFacetsInteractor.ControllerConnection<Controller> {
    let connection = interactor.connectController(controller)
    controllerConnections.append(connection)
    return connection
  }

}
