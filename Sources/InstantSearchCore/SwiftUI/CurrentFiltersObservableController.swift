//
//  CurrentFiltersObservableController.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI)
import Combine
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class CurrentFiltersObservableController: ObservableObject, CurrentFiltersController {

  @Published public var filters: [FilterAndID]

  public func setItems(_ filters: [FilterAndID]) {
    self.filters = filters
  }

  public var onRemoveItem: ((FilterAndID) -> Void)?

  public func reload() {
    objectWillChange.send()
  }

  public init(filters: [FilterAndID] = []) {
    self.filters = filters
  }

}
#endif
