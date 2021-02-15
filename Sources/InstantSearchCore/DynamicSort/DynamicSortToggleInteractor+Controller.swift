//
//  DynamicSortToggleInteractor+Controller.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation

/// Controller presenting the dynamic sort priority applied to the search and a toggle control 
public protocol DynamicSortToggleController: ItemController {

  var didToggle: (() -> Void)? { get set }

}

extension DynamicSortToggleInteractor {

  public struct ControllerConnection<Controller: DynamicSortToggleController, Output>: Connection where Controller.Item == Output {

    public typealias Presenter = InstantSearchCore.Presenter<DynamicSortPriority?, Output>

    public let interactor: DynamicSortToggleInteractor
    public let controller: Controller
    public let presenter: Presenter
    internal var superConnection: Connection!

    public init(interactor: DynamicSortToggleInteractor,
                controller: Controller,
                presenter: @escaping Presenter) {
      self.interactor = interactor
      self.controller = controller
      self.presenter = presenter
      superConnection =  ItemInteractor.ControllerConnection(interactor: interactor,
                                                             controller: controller,
                                                             presenter: presenter )
    }

    public func connect() {
      superConnection.connect()
      controller.didToggle = interactor.toggle
    }

    public func disconnect() {
      superConnection.disconnect()
      controller.didToggle = nil
    }

  }

  @discardableResult public func connectController<Controller: DynamicSortToggleController, Output>(_ controller: Controller,

                                                                                                    presenter: @escaping Presenter<DynamicSortPriority?, Output>) -> DynamicSortToggleInteractor.ControllerConnection<Controller, Output> where Output == Controller.Item {
    let connection = DynamicSortToggleInteractor.ControllerConnection<Controller, Output>(interactor: self,
                                                                                          controller: controller,
                                                                                          presenter: presenter)
    connection.connect()
    return connection
  }

}

extension DynamicSortToggleInteractor {

  public typealias TextualRepresentation = (hint: String, buttonTitle: String)
  public typealias TextualPresenter = Presenter<DynamicSortPriority?, TextualRepresentation?>

  @discardableResult public func connectController<Controller: DynamicSortToggleController>(_ controller: Controller,
                                                                                            presenter: @escaping TextualPresenter = DefaultPresenter.DynamicSortToggle.present) -> ControllerConnection<Controller, TextualRepresentation?> where Controller.Item == TextualRepresentation? {
    let connection = DynamicSortToggleInteractor.ControllerConnection<Controller, TextualRepresentation?>(interactor: self,
                                                                                                          controller: controller,
                                                                                                          presenter: presenter)
    connection.connect()
    return connection
  }

}
