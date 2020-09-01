//
//  FacetListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Component that perform refinements on a facet.
public class FacetListConnector: Connection {
  
  /// Searcher that handles your searches.
  public let searcher: Searcher
  
  /// Filter state that will hold your filters.
  public let filterState: FilterState
  
  /// The logic applied to the facets
  public let interactor: FacetListInteractor
  
  /// The attribute to filter
  public let attribute: Attribute
  
  /// Connection between interactor and filter state
  public let filterStateConnection: Connection
  
  /// Connection between interactor and searcher
  public let searcherConnection: Connection
  
  /// Connection between interactor and controller
  public let controllerConnection: Connection?
  
  internal init<Controller: FacetListController>(searcher: Searcher,
                                                 filterState: FilterState = .init(),
                                                 interactor: FacetListInteractor = .init(),
                                                 controller: Controller,
                                                 presenter: SelectableListPresentable?,
                                                 attribute: Attribute,
                                                 operator: RefinementOperator,
                                                 groupName: String?) {
    
    self.filterState = filterState
    self.searcher = searcher
    self.interactor = interactor
    self.attribute = attribute
    
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               with: attribute,
                                                               operator: `operator`,
                                                               groupName: groupName)
    
    self.controllerConnection = interactor.connectController(controller, with: presenter)
    
    switch searcher {
    case .facet(let facetSearcher):
      searcherConnection = interactor.connectFacetSearcher(facetSearcher)
      
    case .singleIndex(let singleIndexSearcher):
      searcherConnection = interactor.connectSearcher(singleIndexSearcher, with: attribute)
    }
    
  }
  
  internal init(searcher: Searcher,
                filterState: FilterState = .init(),
                interactor: FacetListInteractor = .init(),
                attribute: Attribute,
                operator: RefinementOperator,
                groupName: String?) {
    self.filterState = filterState
    self.searcher = searcher
    self.interactor = interactor
    self.attribute = attribute
    
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               with: attribute,
                                                               operator: `operator`,
                                                               groupName: groupName)
    
    self.controllerConnection = nil
    
    switch searcher {
    case .facet(let facetSearcher):
      searcherConnection = interactor.connectFacetSearcher(facetSearcher)
      
    case .singleIndex(let singleIndexSearcher):
      searcherConnection = interactor.connectSearcher(singleIndexSearcher, with: attribute)
    }
    
  }
  
  /// Initializer with external interactor
  /// - Parameter searcher: Searcher that handles your searches
  /// - Parameter filterState: Filter state that will hold your filters
  /// - Parameter attribute: Attribute to filter
  /// - Parameter interactor: External facet list interactor
  /// - Parameter persistentSelection: When true, the selection will be kept even if it does not match current results anymore.
  /// - Parameter operator: Filter group operator
  /// - Parameter groupName: Filter group name
  /// - Parameter controller: Controller presenting the facets
  /// - Parameter presenter: Presenter defining the appearance of the facet list
  public convenience init<Controller: FacetListController>(searcher: SingleIndexSearcher,
                                                           filterState: FilterState = .init(),
                                                           attribute: Attribute,
                                                           interactor: FacetListInteractor = .init(),
                                                           persistentSelection: Bool = false,
                                                           operator: RefinementOperator,
                                                           groupName: String? = nil,
                                                           controller: Controller,
                                                           presenter: SelectableListPresentable? = nil) {
    searcher.keepSelectedEmptyFacets = persistentSelection
    self.init(searcher: .singleIndex(searcher),
              filterState: filterState,
              interactor: interactor,
              controller: controller,
              presenter: presenter,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }
  
  /// Initializer with external interactor without controller
  /// - Parameter searcher: Searcher that handles your searches
  /// - Parameter filterState: Filter state that will hold your filters
  /// - Parameter attribute: Attribute to filter
  /// - Parameter interactor: External facet list interactor
  /// - Parameter persistentSelection: When true, the selection will be kept even if it does not match current results anymore.
  /// - Parameter operator: Filter group operator
  /// - Parameter groupName: Filter group name
  public convenience init(searcher: SingleIndexSearcher,
                          filterState: FilterState = .init(),
                          attribute: Attribute,
                          interactor: FacetListInteractor = .init(),
                          persistentSelection: Bool = false,
                          operator: RefinementOperator,
                          groupName: String? = nil) {
    searcher.keepSelectedEmptyFacets = persistentSelection
    self.init(searcher: .singleIndex(searcher),
              filterState: filterState,
              interactor: interactor,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }
  
  /// Default initializer
  /// - Parameter searcher: Searcher that handles your searches
  /// - Parameter filterState: Filter state that will hold your filters
  /// - Parameter attribute: Attribute to filter
  /// - Parameter selectionMode: Whether the list can have single or multiple selections
  /// - Parameter facets: If specified, the default facet values to display.
  /// - Parameter persistentSelection: When true, the selection will be kept even if it does not match current results anymore.
  /// - Parameter operator: Filter group operator
  /// - Parameter groupName: Identifier of the group of filters
  /// - Parameter controller: Controller presenting the facet list
  /// - Parameter presenter: Presenter defining the appearance of the facet list
  public convenience init<Controller: FacetListController>(searcher: SingleIndexSearcher,
                                                           filterState: FilterState = .init(),
                                                           attribute: Attribute,
                                                           selectionMode: SelectionMode,
                                                           facets: [Facet] = [],
                                                           persistentSelection: Bool = false,
                                                           operator: RefinementOperator,
                                                           groupName: String? = nil,
                                                           controller: Controller,
                                                           presenter: SelectableListPresentable? = nil) {
    searcher.keepSelectedEmptyFacets = persistentSelection
    self.init(searcher: .singleIndex(searcher),
              filterState: filterState,
              interactor: .init(facets: facets, selectionMode: selectionMode),
              controller: controller,
              presenter: presenter,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }
  
  /// Default initializer without controller
  /// - Parameter searcher: Searcher that handles your searches
  /// - Parameter filterState: Filter state that will hold your filters
  /// - Parameter attribute: Attribute to filter
  /// - Parameter selectionMode: Whether the list can have single or multiple selections
  /// - Parameter facets: If specified, the default facet values to display.
  /// - Parameter persistentSelection: When true, the selection will be kept even if it does not match current results anymore.
  /// - Parameter operator: Filter group operator
  /// - Parameter groupName: Identifier of the group of filters
  public convenience init(searcher: SingleIndexSearcher,
                          filterState: FilterState = .init(),
                          attribute: Attribute,
                          selectionMode: SelectionMode,
                          facets: [Facet] = [],
                          persistentSelection: Bool = false,
                          operator: RefinementOperator,
                          groupName: String? = nil) {
    searcher.keepSelectedEmptyFacets = persistentSelection
    self.init(searcher: .singleIndex(searcher),
              filterState: filterState,
              interactor: .init(facets: facets, selectionMode: selectionMode),
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }
  
  
  public func connect() {
    filterStateConnection.connect()
    searcherConnection.connect()
    controllerConnection?.connect()
  }
  
  public func disconnect() {
    filterStateConnection.disconnect()
    searcherConnection.disconnect()
    controllerConnection?.disconnect()
  }
  
}

extension FacetListConnector {
  
  public enum Searcher {
    case singleIndex(SingleIndexSearcher)
    case facet(FacetSearcher)
  }
  
}
