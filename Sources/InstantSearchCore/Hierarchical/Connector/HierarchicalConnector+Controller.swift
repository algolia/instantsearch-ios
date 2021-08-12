//
//  HierarchicalConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension HierarchicalConnector {

  typealias HierarchicalPresenter<Output> = ([HierarchicalFacet]) -> Output

  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - filterState: FilterState that holds your filters
     - hierarchicalAttributes: Names of the hierarchical attributes that we need to target, in ascending order.
     - separator: String separating the facets in the hierarchical facets.
     - controller: Controller interfacing with a concrete hierarchical view
     - presenter: Presenter defining how hierarchical facets appears in the controller
  */
  convenience init<Controller: HierarchicalController, Output>(searcher: HitsSearcher,
                                                               filterState: FilterState,
                                                               hierarchicalAttributes: [Attribute],
                                                               separator: String,
                                                               controller: Controller,
                                                               presenter: @escaping HierarchicalPresenter<Output>) where Controller.Item == Output {
    self.init(searcher: searcher,
              filterState: filterState,
              hierarchicalAttributes: hierarchicalAttributes,
              separator: separator)
    connectController(controller, presenter: presenter)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete hierarchical view
     - presenter: Presenter defining how hierarchical facets appears in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: HierarchicalController, Output>(_ controller: Controller,
                                                                                        presenter: @escaping HierarchicalPresenter<Output>) -> Hierarchical.ControllerConnection<Controller, Output> {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

}
