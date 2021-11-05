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
   - controller: Controller interfacing with a concrete sortBy view
   - presenter: Presenter defining how the indices appear in the controller
   */
  convenience init<Searcher: AnyObject & Searchable & IndexNameSettable, Controller: SelectableSegmentController>(searcher: Searcher,
                                                                                                                  indicesNames: [IndexName],
                                                                                                                  selected: Int? = nil,
                                                                                                                  controller: Controller,
                                                                                                                  presenter: @escaping IndexNamePresenter = DefaultPresenter.IndexName.present) where Controller.SegmentKey == Int {
    let enumeratedIndices = indicesNames
      .enumerated()
      .map { $0 }
    let items = [Int: IndexName](uniqueKeysWithValues: enumeratedIndices)
    let interactor = SortByInteractor(items: items)
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
                                                                                     presenter: @escaping IndexNamePresenter = DefaultPresenter.IndexName.present) -> SortByInteractor.ControllerConnection<Controller> where Controller.SegmentKey == Int {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

}
