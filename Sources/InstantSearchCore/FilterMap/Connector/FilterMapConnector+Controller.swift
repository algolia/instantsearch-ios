//
//  FilterMapConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension FilterMapConnector {

  /**
  Init with implicit interactor & controller
  - Parameters:
    - searcher: Searcher handling searches for facet values
    - filterState: FilterState that holds your filters
    - items: Map from segment to filter
    - selected: Initially selected segment
    - attribute: Attribute to filter
    - operator: Whether we apply an `and` or `or` behavior to the filters in the filter state
    - groupName: Filter group name
    - controller: Controller interfacing with a concrete selectable filter view
    - presenter: Presenter defining how a filter appears in the controller
  */
  convenience init<Controller: SelectableSegmentController>(searcher: HitsSearcher,
                                                            filterState: FilterState,
                                                            items: [Int: Filter],
                                                            selected: Int,
                                                            attribute: Attribute,
                                                            `operator`: RefinementOperator,
                                                            groupName: String? = nil,
                                                            controller: Controller,
                                                            presenter: @escaping FilterPresenter = DefaultPresenter.Filter.present) where Controller.SegmentKey == Int {
    self.init(searcher: searcher,
              filterState: filterState,
              items: items,
              selected: selected,
              attribute: attribute,
              operator: `operator`,
              groupName: groupName)
    connectController(controller, presenter: presenter)
  }

  /**
   Establishes a connection with the controller using the provided presentation logic
   - Parameters:
     - controller: Controller interfacing with a concrete selectable filter view
     - presenter: Presenter defining how a filter appears in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: SelectableSegmentController>(_ controller: Controller,
                                                                                     presenter: @escaping FilterPresenter = DefaultPresenter.Filter.present) -> FilterMapInteractorControllerConnection<Filter, Controller> where Controller.SegmentKey == Int {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

}
