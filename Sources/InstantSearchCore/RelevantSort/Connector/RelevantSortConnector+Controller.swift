//
//  RelevantSortConnector+Controller.swift
//
//
//  Created by Vladislav Fitc on 17/02/2021.
//

import Foundation

public extension RelevantSortConnector {

  typealias ControllerConnection = RelevantSortInteractor.ControllerConnection
  typealias Presenter<Output> = RelevantSortPresenter<Output>

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Relevant sort priority toggling logic
     - controller: Controller presenting the relevant sort priority state and capable to toggle it
     - presenter: Generic presenter transforming the relevant sort priority state to its representation for a controller
   */
  convenience init<Controller: RelevantSortController, Output>(searcher: HitsSearcher,
                                                               interactor: RelevantSortInteractor = .init(),
                                                               controller: Controller,
                                                               presenter: @escaping Presenter<Output>) where Controller.Item == Output {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher),
              interactor: interactor)
    connectController(controller, presenter: presenter)
  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - queryIndex: Index of query to alter by relevant sort toggling
     - interactor: Relevant sort priority toggling logic
     - controller: Controller presenting the relevant sort priority state and capable to toggle it
     - presenter: Generic presenter transforming the relevant sort priority state to its representation for a controller
   */
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  convenience init<Controller: RelevantSortController, Output>(searcher: MultiIndexSearcher,
                                                               queryIndex: Int,
                                                               interactor: RelevantSortInteractor = .init(),
                                                               controller: Controller,
                                                               presenter: @escaping Presenter<Output>) where Controller.Item == Output {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher, queryIndex: queryIndex),
              interactor: interactor)
    connectController(controller, presenter: presenter)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller presenting the relevant sort priority state and capable to toggle it
     - presenter: Generic presenter transforming the relevant sort priority state to its representation for a controller
  - Returns: Established connection
   */
  @discardableResult func connectController<Controller: RelevantSortController, Output>(_ controller: Controller,
                                                                                        presenter: @escaping Presenter<Output>) -> ControllerConnection<Controller, Output> where Controller.Item == Output {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

}

public extension RelevantSortConnector {

  typealias TextualPresenter = RelevantSortTextualPresenter
  typealias TextualRepresentation = RelevantSortTextualRepresentation

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: Relevant sort priority toggling logic
     - controller: Controller presenting the relevant sort priority state and capable to toggle it
     - presenter: Presenter transforming the relevant sort priority state to its textual representation in the controller.
                  Default presenter provides a tuple of string constants in english.
   */
  convenience init<Controller: RelevantSortController>(searcher: HitsSearcher,
                                                       interactor: RelevantSortInteractor = .init(),
                                                       controller: Controller,
                                                       presenter: @escaping TextualPresenter = DefaultPresenter.RelevantSort.present) where Controller.Item == TextualRepresentation? {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher),
              interactor: interactor)
    connectController(controller, presenter: presenter)
  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - queryIndex: Index of query to alter by relevant sort toggling
     - interactor: Relevant sort priority toggling logic
     - controller: Controller presenting the relevant sort priority state and capable to toggle it
     - presenter: Presenter transforming the relevant sort priority state to its textual representation in the controller.
                  Default presenter provides a tuple of string constants in english.
   */
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  convenience init<Controller: RelevantSortController>(searcher: MultiIndexSearcher,
                                                       queryIndex: Int,
                                                       interactor: RelevantSortInteractor = .init(),
                                                       controller: Controller,
                                                       presenter: @escaping TextualPresenter = DefaultPresenter.RelevantSort.present) where Controller.Item == TextualRepresentation? {
    self.init(searcher: searcher,
              searcherConnection: interactor.connectSearcher(searcher, queryIndex: queryIndex),
              interactor: interactor)
    connectController(controller, presenter: presenter)
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller presenting the relevant sort priority state and capable to toggle it
   - Returns: Established connection
   */
  @discardableResult func connectController<Controller: RelevantSortController>(_ controller: Controller,
                                                                                presenter: @escaping TextualPresenter = DefaultPresenter.RelevantSort.present) -> ControllerConnection<Controller, TextualRepresentation?> where Controller.Item == TextualRepresentation? {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

}
