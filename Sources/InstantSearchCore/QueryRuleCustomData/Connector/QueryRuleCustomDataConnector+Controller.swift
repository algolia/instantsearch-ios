//
//  QueryRuleCustomDataConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 10/10/2020.
//

import Foundation

public extension QueryRuleCustomDataConnector {

  /**
   - Parameters:
     - searcher: Searcher that handles your searches
     - interactor: External custom data interactor
     - controller: Controller interfacing with a concrete custom data view
     - presenter: Presenter defining how a model appears in the controller
  */
  convenience init<Controller: ItemController, Output>(searcher: HitsSearcher,
                                                       interactor: Interactor = .init(),
                                                       controller: Controller,
                                                       presenter: @escaping (Model?) -> Output) where Controller.Item == Output {

    self.init(searcher: searcher, interactor: interactor)
    let controllerConnection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(controllerConnection)
  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - interactor: External custom data interactor
     - controller: Controller interfacing with a concrete custom data view
  */
  convenience init<Controller: ItemController>(searcher: HitsSearcher,
                                               interactor: Interactor = .init(),
                                               controller: Controller) where Controller.Item == Model? {
    self.init(searcher: searcher, interactor: interactor)
    let controllerConnection = interactor.connectController(controller, presenter: { $0 })
    controllerConnections.append(controllerConnection)
  }

}

public extension QueryRuleCustomDataConnector {

  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - queryIndex: Index of query from response of which the user data will be extracted
     - interactor: External custom data interactor
     - controller: Controller interfacing with a concrete custom data view
     - presenter: Presenter defining how a model appears in the controller
  */
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  convenience init<Controller: ItemController, Output>(searcher: MultiIndexSearcher,
                                                       queryIndex: Int,
                                                       interactor: Interactor = .init(),
                                                       controller: Controller,
                                                       presenter: @escaping (Model?) -> Output) where Controller.Item == Output {

    self.init(searcher: searcher, queryIndex: queryIndex, interactor: interactor)
    let controllerConnection = interactor.connectController(controller, presenter: presenter)
    controllerConnections = [controllerConnection]
  }

  /**
   - Parameters:
     - searcher: Searcher that handles your searches.
     - queryIndex: Index of query from response of which the user data will be extracted
     - interactor: External custom data interactor
     - controller: Controller interfacing with a concrete custom data view
  */
  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with CompositeSearcher instead of MultiIndexSearcher")
  convenience init<Controller: ItemController>(searcher: MultiIndexSearcher,
                                               queryIndex: Int,
                                               interactor: Interactor = .init(),
                                               controller: Controller) where Controller.Item == Model? {
    self.init(searcher: searcher, queryIndex: queryIndex, interactor: interactor)
    let controllerConnection = interactor.connectController(controller, presenter: { $0 })
    controllerConnections.append(controllerConnection)
  }

}

public extension QueryRuleCustomDataConnector {

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete custom data view
     - presenter: Presenter defining how a model appears in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: ItemController, Output>(_ controller: Controller,
                                                                                presenter: @escaping (Model?) -> Output) -> QueryRuleCustomDataInteractor<Model>.ControllerConnection<Controller, Output> {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

  /**
   Establishes a connection with the controller
   - Parameters:
     - controller: Controller interfacing with a concrete custom data view
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: ItemController>(_ controller: Controller) -> QueryRuleCustomDataInteractor<Model>.ControllerConnection<Controller, Model?> {
    let connection = interactor.connectController(controller, presenter: { $0 })
    controllerConnections.append(connection)
    return connection
  }

}
