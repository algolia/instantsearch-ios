//
//  RelevantSortInteractor+Controller.swift
//  
//
//  Created by Vladislav Fitc on 10/02/2021.
//

import Foundation

/// Controller presenting the relevant sort priority applied to the search and a toggle control
public protocol RelevantSortController: ItemController {

  /// Closure triggered by the controller when toggle interaction occured (for example, toggle button clicked or switch control state changed)
  var didToggle: (() -> Void)? { get set }

}

/// Generic presenter of the relevant sort priority state
public typealias RelevantSortPresenter<Output> = Presenter<RelevantSortPriority?, Output>

public extension RelevantSortInteractor {

  typealias Presenter<Output> = RelevantSortPresenter<Output>

  /// Connection between relevant sort interactor and its controller
  struct ControllerConnection<Controller: RelevantSortController, Output>: Connection where Controller.Item == Output {

    /// Relevant sort priority toggling logic
    public let interactor: RelevantSortInteractor

    /// Controller presenting the relevant sort priority state and capable to toggle it
    public let controller: Controller

    /// Generic presenter transforming the relevant sort priority state to its representation for a controller
    public let presenter: Presenter<Output>

    internal let superConnection: Connection

    /**
     - Parameters:
       - interactor: Relevant sort priority toggling logic
       - controller: Controller presenting the relevant sort priority state and capable to toggle it
       - presenter: Generic presenter transforming the relevant sort priority state to its representation in the controller
     */
    public init(interactor: RelevantSortInteractor,
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

// Connect to a controller generically representing the relevant sort priority state
public extension RelevantSortInteractor {

  /**
   Establishes a connection with the controller using the provided presentation logic
   - Parameters:
     - controller: Controller presenting the relevant sort priority state and capable to toggle it
     - presenter: Generic presenter transforming the relevant sort priority state to its representation in the controller
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: RelevantSortController, Output>(_ controller: Controller,
                                                                                        presenter: @escaping Presenter<Output>) -> ControllerConnection<Controller, Output> where Output == Controller.Item {
    let connection = RelevantSortInteractor.ControllerConnection<Controller, Output>(interactor: self,
                                                                                     controller: controller,
                                                                                     presenter: presenter)
    connection.connect()
    return connection
  }

}

/// Textual representation of relevant priority states consisting of hint text that explains current sort priority state
/// and the toggle title that switches the state
public typealias RelevantSortTextualRepresentation = (hintText: String, toggleTitle: String)

/// Textual presenter for relevant sort priority state
public typealias RelevantSortTextualPresenter = RelevantSortPresenter<RelevantSortTextualRepresentation?>

// Connect to a controller textually representing the relevant sort priority state
public extension RelevantSortInteractor {

  typealias TextualPresenter = RelevantSortTextualPresenter
  typealias TextualRepresentation = RelevantSortTextualRepresentation

  /**
   Establishes a connection with the controller using the provided textual presentation logic
   - Parameters:
     - controller: Controller presenting the relevant sort priority state and capable to toggle it
     - presenter: Presenter transforming the relevant sort priority state to its textual representation in the controller.
                  Default presenter provides a tuple of string constants in english.
   - Returns: Established connection
  */
  @discardableResult func connectController<Controller: RelevantSortController>(_ controller: Controller,
                                                                                presenter: @escaping TextualPresenter = DefaultPresenter.RelevantSort.present) -> ControllerConnection<Controller, TextualRepresentation?> where Controller.Item == TextualRepresentation? {
    let connection = RelevantSortInteractor.ControllerConnection<Controller, TextualRepresentation?>(interactor: self,
                                                                                                     controller: controller,
                                                                                                     presenter: presenter)
    connection.connect()
    return connection
  }

}
