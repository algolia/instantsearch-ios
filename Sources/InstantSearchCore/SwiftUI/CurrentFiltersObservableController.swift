//
//  CurrentFiltersObservableController.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class CurrentFiltersObservableController: ObservableObject, CurrentFiltersController {

  @Published public var isEmpty: Bool

  public func setItems(_ items: [FilterAndID]) {
    isEmpty = items.isEmpty
  }

  public var onRemoveItem: ((FilterAndID) -> Void)?

  public func reload() {
    objectWillChange.send()
  }

  public init(isEmpty: Bool = true) {
    self.isEmpty = isEmpty
  }

}
