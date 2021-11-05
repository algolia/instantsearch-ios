//
//  StatsConnector+Controller.swift
//  
//
//  Created by Vladislav Fitc on 17/09/2020.
//

import Foundation

public extension StatsConnector {

  /**
    - Parameters:
      - searcher: Searcher that handles your searches
      - interactor: Logic applied to the stats
      - controller: Controller interfacing with a concrete stats view
      - presenter: Presenter defining how stats appear in the controller
   */
  convenience init<Controller: ItemController, Output>(searcher: HitsSearcher,
                                                       interactor: StatsInteractor = .init(),
                                                       controller: Controller,
                                                       presenter: @escaping Presenter<SearchStats?, Output>) where Controller.Item == Output {
    self.init(searcher: searcher,
              interactor: interactor)
    connectController(controller, presenter: presenter)
  }

  /**
   - Parameters:
   - searcher: Searcher that handles your searches
   - interactor: Logic applied to the stats
   - controller: Controller interfacing with a concrete stats view
   - presenter: Presenter defining how stats appear in the controller
   */
  convenience init<Controller: ItemController>(searcher: HitsSearcher,
                                               interactor: StatsInteractor = .init(),
                                               controller: Controller,
                                               presenter: @escaping Presenter<SearchStats?, String?> = DefaultPresenter.Stats.present) where Controller.Item == String? {
    self.init(searcher: searcher,
              interactor: interactor)
    connectController(controller, presenter: presenter)
  }

  /**
   Establishes a connection with the controller using the provided presentation logic
   - Parameters:
     - controller: Controller interfacing with a concrete stats view
     - presenter: Presenter defining how stats appear in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: ItemController, Output>(_ controller: Controller,
                                                                                presenter: @escaping Presenter<SearchStats?, Output>) -> ItemInteractor<SearchStats?>.ControllerConnection<Controller, Output> {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

  /**
   Establishes a connection with the controller using the provided presentation logic
   - Parameters:
     - controller: Controller interfacing with a concrete stats view
     - presenter: Presenter defining how stats appear in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: ItemController>(_ controller: Controller,
                                                                        presenter: @escaping Presenter<SearchStats?, String?>  = DefaultPresenter.Stats.present) -> ItemInteractor<SearchStats?>.ControllerConnection<Controller, String?> {
    let connection = interactor.connectController(controller, presenter: presenter)
    controllerConnections.append(connection)
    return connection
  }

}
