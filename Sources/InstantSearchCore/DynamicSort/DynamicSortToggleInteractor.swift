//
//  DynamicSortToggleInteractor.swift
//  
//
//  Created by Vladislav Fitc on 04/02/2021.
//

import Foundation

public enum DynamicSortPriority {
  case relevancy
  case hitsCount
}

public class DynamicSortToggleInteractor: ItemInteractor<DynamicSortPriority> {
  
  public init() {
    super.init(item: .relevancy)
  }
  
}

public protocol DynamicSortToggleController: ItemController {
  
  var didToggle: (() -> Void)? { get set }

}

public extension DynamicSortToggleInteractor {
  
  func toggle() {
    switch item {
    case .hitsCount:
      item = .relevancy
    case .relevancy:
      item = .hitsCount
    }
  }
  
  func relevancyStrictness(for priority: DynamicSortPriority) -> Int {
    switch priority {
    case .hitsCount:
      return 0
    case .relevancy:
      return 100
    }
  }
  
}

extension DynamicSortToggleInteractor {
  
  public struct ControllerConnection<Controller: DynamicSortToggleController, Output>: Connection where Controller.Item == Output {
    
    public typealias Presenter = InstantSearchCore.Presenter<DynamicSortPriority, Output>

    public let interactor: DynamicSortToggleInteractor
    public let controller: Controller
    public let presenter: Presenter
    internal var superConnection: Connection

    public init(interactor: DynamicSortToggleInteractor, controller: Controller, presenter: @escaping Presenter) {
      self.interactor = interactor
      self.controller = controller
      self.presenter = presenter
      superConnection = (interactor as ItemInteractor).connectController(controller, presenter: presenter)
      controller.didToggle = interactor.toggle
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
                                                                                 
                                                                                                    presenter: @escaping Presenter<DynamicSortPriority, Output>) -> DynamicSortToggleInteractor.ControllerConnection<Controller, Output> where Output == Controller.Item {
    return ControllerConnection(interactor: self, controller: controller, presenter: presenter)
  }
  
  
}

extension DynamicSortToggleInteractor {
  
  public struct SearchResponseProviderConnection<SearchResponseProvider: SearchResultObservable>: Connection where SearchResponseProvider.SearchResult == SearchResponse {
    
    public let interactor: DynamicSortToggleInteractor
    public let provider: SearchResponseProvider
    
    public init(interactor: DynamicSortToggleInteractor, provider: SearchResponseProvider) {
      self.interactor = interactor
      self.provider = provider
    }

    public func connect() {
      provider.onResults.subscribe(with: interactor) { (interactor, searchResponse) in
//        searchResponse.app
      }
    }
    
    public func disconnect() {
      
    }
    
  }
  
}
