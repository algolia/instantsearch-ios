//
//  SmartSortConnector+Controller.swift
//
//
//  Created by Vladislav Fitc on 17/02/2021.
//
// swiftlint:disable line_length

import Foundation

public extension SmartSortConnector {

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Smart sort priority toggling logic
     - controller: Controller presenting the smart sort priority state and capable to toggle it
     - presenter: Generic presenter transforming the smart sort priority state to its representation for a controller
   */
  convenience init<Controller: SmartSortController, Output>(searcher: SingleIndexSearcher,
                                                            interactor: SmartSortInteractor = .init(),
                                                            controller: Controller,
                                                            presenter: @escaping SmartSortPresenter<Output>) where Controller.Item == Output {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher),
              interactor: interactor)
    connectController(controller, presenter: presenter)
  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - queryIndex: Index of query to alter by smart sort toggling
     - interactor: Smart sort priority toggling logic
     - controller: Controller presenting the smart sort priority state and capable to toggle it
     - presenter: Generic presenter transforming the smart sort priority state to its representation for a controller
   */
  convenience init<Controller: SmartSortController, Output>(searcher: MultiIndexSearcher,
                                                            queryIndex: Int,
                                                            interactor: SmartSortInteractor = .init(),
                                                            controller: Controller,
                                                            presenter: @escaping SmartSortPresenter<Output>) where Controller.Item == Output {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher, queryIndex: queryIndex),
              interactor: interactor)
    connectController(controller, presenter: presenter)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller presenting the smart sort priority state and capable to toggle it
     - presenter: Generic presenter transforming the smart sort priority state to its representation for a controller
  - Returns: Established connection
   */
  @discardableResult func connectController<Controller: SmartSortController, Output>(_ controller: Controller,
                                                                                     presenter: @escaping SmartSortPresenter<Output>) -> SmartSortInteractor.ControllerConnection<Controller, Output> where Controller.Item == Output {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

}

public extension SmartSortConnector {

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Smart sort priority toggling logic
     - controller: Controller presenting the smart sort priority state and capable to toggle it
     - presenter: Presenter transforming the smart sort priority state to its textual representation in the controller.
                  Default presenter provides a tuple of string constants in english.
   */
  convenience init<Controller: SmartSortController>(searcher: SingleIndexSearcher,
                                                    interactor: SmartSortInteractor = .init(),
                                                    controller: Controller,
                                                    presenter: @escaping SmartSortTextualPresenter = DefaultPresenter.SmartSort.present) where Controller.Item == SmartSortTextualRepresentation? {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher),
              interactor: interactor)
    connectController(controller, presenter: presenter)
  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - queryIndex: Index of query to alter by smart sort toggling
     - interactor: Smart sort priority toggling logic
     - controller: Controller presenting the smart sort priority state and capable to toggle it
     - presenter: Presenter transforming the smart sort priority state to its textual representation in the controller.
                  Default presenter provides a tuple of string constants in english.
   */
  convenience init<Controller: SmartSortController>(searcher: MultiIndexSearcher,
                                                    queryIndex: Int,
                                                    interactor: SmartSortInteractor = .init(),
                                                    controller: Controller,
                                                    presenter: @escaping SmartSortTextualPresenter = DefaultPresenter.SmartSort.present) where Controller.Item == SmartSortTextualRepresentation? {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher, queryIndex: queryIndex),
              interactor: interactor)
    connectController(controller, presenter: presenter)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller presenting the smart sort priority state and capable to toggle it
   - Returns: Established connection
   */
  @discardableResult func connectController<Controller: SmartSortController>(_ controller: Controller,
                                                                             presenter: @escaping SmartSortTextualPresenter = DefaultPresenter.SmartSort.present) -> SmartSortInteractor.ControllerConnection<Controller, SmartSortTextualRepresentation?> where Controller.Item == SmartSortTextualRepresentation? {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

}
