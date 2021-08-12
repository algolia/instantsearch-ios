//
//  SortByConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension SortByConnector {

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - indicesNames: List of indices to search in
     - selected: Consecutive index of the initially selected search index in the list
     - controller: Controller interfacing with a concrete switch index view
     - presenter: Presenter defining how the indices appear in the controller
   */
  convenience init<Controller: SelectableSegmentController>(searcher: HitsSearcher,
                                                            indicesNames: [IndexName],
                                                            selected: Int? = nil,
                                                            controller: Controller,
                                                            presenter: @escaping IndexPresenter = DefaultPresenter.Index.present) where Controller.SegmentKey == Int {
    let enumeratedIndices = indicesNames
      .map(searcher.service.client.index(withName:))
      .enumerated()
      .map { $0 }
    let items = [Int: Index](uniqueKeysWithValues: enumeratedIndices)
    let interactor = IndexSegmentInteractor(items: items)
    interactor.selected = selected
    self.init(searcher: searcher, interactor: interactor)
    connectController(controller, presenter: presenter)
  }

  /**
   Establishes a connection with the controller using the provided presentation logic
   - Parameters:
     - controller: Controller interfacing with a concrete switch index view
     - presenter: Presenter defining how the indices appear in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: SelectableSegmentController>(_ controller: Controller,
                                                                                     presenter: @escaping IndexPresenter = DefaultPresenter.Index.present) -> IndexSegment.ControllerConnection<Controller> where Controller.SegmentKey == Int {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

}
