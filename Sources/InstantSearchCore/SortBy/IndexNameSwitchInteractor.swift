//
//  SwitchIndexInteractor.swift
//  
//
//  Created by Vladislav Fitc on 30/11/2020.
//

import Foundation
import AlgoliaSearchClient

public final class IndexNameSwitchInteractor: SelectableSegmentInteractor<Int, IndexName> {}

public protocol IndexNameSwitchable: class {
  
  func switchIndexName(to indexName: IndexName)
  
}

extension IndexNameSwitchInteractor {
  
  struct IndexNameSwitchableConnection<T: IndexNameSwitchable>: Connection {
    
    let interactor: IndexNameSwitchInteractor
    let target: T
    
    init(interactor: IndexNameSwitchInteractor, target: T) {
      self.interactor = interactor
      self.target = target
    }
    
    func connect() {
      interactor.onSelectedComputed.subscribePast(with: target) { [weak interactor] target, computed in
        if
          let selected = computed,
          let index = interactor?.items[selected]
        {
          interactor?.selected = selected
          target.switchIndexName(to: index)
        }
      }
    }
    
    func disconnect() {
      interactor.onSelectedComputed.cancelSubscription(for: target)
    }
    
  }
  
}

extension IndexNameSwitchInteractor {
  
  struct SelectableSegmentControllerConnection<Controller: SelectableSegmentController>: Connection where Controller.SegmentKey == Int {

    public let interactor: IndexNameSwitchInteractor
    public let controller: Controller
    public let presenter: (IndexName) -> String

    public init(interactor: IndexNameSwitchInteractor,
                controller: Controller,
                presenter: @escaping (IndexName) -> String = { $0.rawValue }) {
      self.interactor = interactor
      self.controller = controller
      self.presenter = presenter
    }

    public func connect() {
      controller.setItems(items: interactor.items.mapValues(presenter))
      controller.onClick = interactor.computeSelected(selecting:)
      interactor.onSelectedChanged.subscribePast(with: controller) { controller, selectedItem in
        controller.setSelected(selectedItem)
      }.onQueue(.main)
      interactor.onItemsChanged.subscribePast(with: controller) { controller, newItems in
        controller.setItems(items: newItems.mapValues(self.presenter))
      }.onQueue(.main)
    }

    public func disconnect() {
      controller.setItems(items: [:])
      controller.onClick = nil
      interactor.onSelectedChanged.cancelSubscription(for: controller)
      interactor.onItemsChanged.cancelSubscription(for: controller)
    }

  }
  
}

extension IndexSearcher: IndexNameSwitchable {
  
  public func switchIndexName(to indexName: IndexName) {
    request.indexName = indexName
  }
  
}
