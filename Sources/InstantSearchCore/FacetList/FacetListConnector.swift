//
//  FacetListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class FacetListConnector: Connection {
  
  public enum Searcher {
    case singleIndex(SingleIndexSearcher)
    case facet(FacetSearcher)
  }
  
  public let filterState: FilterState
  public let searcher: Searcher
  public let interactor: FacetListInteractor
  public let attribute: Attribute
  
  public let filterStateConnection: Connection
  public let searcherConnection: Connection
  public let controllerConnection: Connection?
  
  internal init<Controller: FacetListController>(searcher: Searcher,
                                                 filterState: FilterState = .init(),
                                                 interactor: FacetListInteractor = .init(),
                                                 controller: Controller? = nil,
                                                 attribute: Attribute,
                                                 operator: RefinementOperator,
                                                 groupName: String? = nil) {
    
    self.filterState = filterState
    self.searcher = searcher
    self.interactor = interactor
    self.attribute = attribute
    
    self.filterStateConnection = interactor.connectFilterState(filterState,
                                                               with: attribute,
                                                               operator: `operator`,
                                                               groupName: groupName)
    
    if let controller = controller {
      self.controllerConnection = interactor.connectController(controller)
    } else {
      self.controllerConnection = nil
    }
    
    switch searcher {
    case .facet(let facetSearcher):
      searcherConnection = interactor.connectFacetSearcher(facetSearcher)
      
    case .singleIndex(let singleIndexSearcher):
      searcherConnection = interactor.connectSearcher(singleIndexSearcher, with: attribute)
    }
    
  }
  
  public convenience init<Controller: FacetListController>(searcher: SingleIndexSearcher,
                                                           filterState: FilterState = .init(),
                                                           attribute: Attribute,
                                                           operator: RefinementOperator,
                                                           groupName: String? = nil,
                                                           interactor: FacetListInteractor = .init(),
                                                           controller: Controller? = nil) {
    self.init(searcher: .singleIndex(searcher),
              filterState: filterState,
              interactor: interactor,
              controller: controller,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }
  
  public convenience init<Controller: FacetListController>(searcher: FacetSearcher,
                                                           filterState: FilterState = .init(),
                                                           attribute: Attribute,
                                                           operator: RefinementOperator,
                                                           groupName: String? = nil,
                                                           interactor: FacetListInteractor = .init(),
                                                           controller: Controller? = nil) {
    self.init(searcher: .facet(searcher),
              filterState: filterState,
              interactor: interactor,
              controller: controller,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }
  
  public convenience init<Controller: FacetListController>(searcher: SingleIndexSearcher,
                                                           filterState: FilterState = .init(),
                                                           attribute: Attribute,
                                                           facets: [Facet],
                                                           selectionMode: SelectionMode,
                                                           operator: RefinementOperator,
                                                           groupName: String? = nil,
                                                           controller: Controller? = nil) {
    self.init(searcher: .singleIndex(searcher),
              filterState: filterState,
              interactor: .init(facets: facets, selectionMode: selectionMode),
              controller: controller,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
  }
  
  public convenience init<Controller: FacetListController>(searcher: FacetSearcher,
                                                           filterState: FilterState = .init(),
                                                           attribute: Attribute,
                                                           facets: [Facet],
                                                           selectionMode: SelectionMode,
                                                           operator: RefinementOperator,
                                                           groupName: String? = nil,
                                                           controller: Controller? = nil) {
    self.init(searcher: .facet(searcher),
              filterState: filterState,
              interactor: .init(facets: facets, selectionMode: selectionMode),
              controller: controller,
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
