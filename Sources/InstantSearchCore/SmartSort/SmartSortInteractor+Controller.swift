//
//  SmartSortInteractor+Controller.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation

/// Controller presenting the smart sort priority applied to the search and a toggle control 
public protocol SmartSortController: ItemController {

  /// Closure triggered by the controller when toggle interaction occured (for example, toggle button clicked or switch control state changed)
  var didToggle: (() -> Void)? { get set }

}

extension SmartSortInteractor {

  /// Generic presenter of the smart sort priority state
  public typealias Presenter<Output> = InstantSearchCore.Presenter<SmartSortPriority?, Output>

  /// Connection between smart sort interactor and its controller
  public struct ControllerConnection<Controller: SmartSortController, Output>: Connection where Controller.Item == Output {

    /// Smart sort priority toggling logic
    public let interactor: SmartSortInteractor

    /// Controller presenting the smart sort priority state and capable to toggle it
    public let controller: Controller

    /// Generic presenter transforming the smart sort priority state to its representation for a controller
    public let presenter: Presenter<Output>

    internal let superConnection: Connection

    /**
     - Parameters:
       - interactor: Smart sort priority toggling logic
       - controller: Controller presenting the smart sort priority state and capable to toggle it
       - presenter: Generic presenter transforming the smart sort priority state to its representation in the controller
     */
    public init(interactor: SmartSortInteractor,
                controller: Controller,
                presenter: @escaping Presenter<Output>) {
      self.interactor = interactor
      self.controller = controller
      self.presenter = presenter
      superConnection = ItemInteractor.ControllerConnection(interactor: interactor,
                                                            controller: controller,
                                                            presenter: presenter)
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

}

// Connect to a controller generically representing the smart sort priority state
extension SmartSortInteractor {

  /**
   Establishes a connection with the controller using the provided presentation logic
   - Parameters:
     - controller: Controller presenting the smart sort priority state and capable to toggle it
     - presenter: Generic presenter transforming the smart sort priority state to its representation in the controller
   - Returns: Established connection
  */
  @discardableResult public func connectController<Controller: SmartSortController, Output>(_ controller: Controller,

                                                                                                    presenter: @escaping Presenter<Output>) -> SmartSortInteractor.ControllerConnection<Controller, Output> where Output == Controller.Item {
    let connection = SmartSortInteractor.ControllerConnection<Controller, Output>(interactor: self,
                                                                                          controller: controller,
                                                                                          presenter: presenter)
    connection.connect()
    return connection
  }

}

// Connect to a controller textually representing the smart sort priority state
extension SmartSortInteractor {

  /// Textual representation of smart priority states consisting of hint text that explains current sort priority state
  /// and the toggle title that switches the state
  public typealias TextualRepresentation = (hintText: String, toggleTitle: String)

  /// Textual presenter for smart sort priority state
  public typealias TextualPresenter = Presenter<TextualRepresentation?>

  /**
   Establishes a connection with the controller using the provided textual presentation logic
   - Parameters:
     - controller: Controller presenting the smart sort priority state and capable to toggle it
     - presenter: Presenter transforming the smart sort priority state to its textual representation in the controller.
                  Default presenter provides a tuple of string constants in english.
   - Returns: Established connection
  */
  @discardableResult public func connectController<Controller: SmartSortController>(_ controller: Controller,
                                                                                            presenter: @escaping TextualPresenter = DefaultPresenter.SmartSort.present) -> ControllerConnection<Controller, TextualRepresentation?> where Controller.Item == TextualRepresentation? {
    let connection = SmartSortInteractor.ControllerConnection<Controller, TextualRepresentation?>(interactor: self,
                                                                                                          controller: controller,
                                                                                                          presenter: presenter)
    connection.connect()
    return connection
  }

}
