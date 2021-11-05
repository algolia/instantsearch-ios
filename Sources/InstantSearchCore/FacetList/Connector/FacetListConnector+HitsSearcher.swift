//
//  FacetListConnector+HitsSearcher.swift
//  
//
//  Created by Vladislav Fitc on 15/09/2020.
//

import Foundation

public extension FacetListConnector {

  /**
  Init with explicit interactor
  - Parameters:
    - searcher: Searcher that handles your searches
    - filterState: FilterState that holds your filters
    - attribute: Attribute to filter
    - interactor: External facet list interactor
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state
    - groupName: Filter group name
  */
  convenience init(searcher: HitsSearcher,
                   filterState: FilterState = .init(),
                   attribute: Attribute,
                   interactor: FacetListInteractor = .init(),
                   operator: RefinementOperator,
                   groupName: String? = nil) {
    self.init(searcher: .hits(searcher),
              filterState: filterState,
              interactor: interactor,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }

  /**
  Init with an explicit interactor & controller
  - Parameters:
    - searcher: Searcher that handles your searches
    - filterState: FilterState that holds your filters
    - attribute: Attribute to filter
    - interactor: External facet list interactor
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state
    - groupName: Filter group name
    - controller: Controller interfacing with a concrete facet list view
    - presenter: Presenter defining how a facet appears in the controller
  */
  convenience init<Controller: FacetListController>(searcher: HitsSearcher,
                                                    filterState: FilterState = .init(),
                                                    attribute: Attribute,
                                                    interactor: FacetListInteractor = .init(),
                                                    operator: RefinementOperator,
                                                    groupName: String? = nil,
                                                    controller: Controller,
                                                    presenter: SelectableListPresentable? = nil) {
    self.init(searcher: .hits(searcher),
              filterState: filterState,
              interactor: interactor,
              controller: controller,
              presenter: presenter,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }

  /**
  Init with implicit interactor
  - Parameters:
    - searcher: Searcher that handles your searches
    - filterState: FilterState that holds your filters
    - attribute: Attribute to filter
    - selectionMode: Whether a user can select .single or .multiple values
    - facets: If specified, the default facet value(s) to apply
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state
    - groupName: Filter group name
  */
  convenience init(searcher: HitsSearcher,
                   filterState: FilterState = .init(),
                   attribute: Attribute,
                   selectionMode: SelectionMode,
                   facets: [Facet] = [],
                   persistentSelection: Bool = false,
                   operator: RefinementOperator,
                   groupName: String? = nil) {
    self.init(searcher: .hits(searcher),
              filterState: filterState,
              interactor: .init(facets: facets, selectionMode: selectionMode),
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }

  /**
  Init with implicit interactor & controller
  - Parameters:
      - searcher: Searcher that handles your searches
      - filterState: FilterState that holds your filters
      - attribute: Attribute to filter
      - selectionMode: Whether a user can select .single or .multiple values
      - facets: If specified, the default facet value(s) to apply
      - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state
      - groupName: Filter group name
      - controller: Controller interfacing with a concrete facet list view
      - presenter: Presenter defining how a facet appears in the controller
  */
  convenience init<Controller: FacetListController>(searcher: HitsSearcher,
                                                    filterState: FilterState = .init(),
                                                    attribute: Attribute,
                                                    selectionMode: SelectionMode,
                                                    facets: [Facet] = [],
                                                    persistentSelection: Bool = false,
                                                    operator: RefinementOperator,
                                                    groupName: String? = nil,
                                                    controller: Controller,
                                                    presenter: SelectableListPresentable? = nil) {
    self.init(searcher: .hits(searcher),
              filterState: filterState,
              interactor: .init(facets: facets, selectionMode: selectionMode),
              controller: controller,
              presenter: presenter,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }

}
