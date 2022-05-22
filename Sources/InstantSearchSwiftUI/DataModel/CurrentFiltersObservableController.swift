//
//  CurrentFiltersObservableController.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// CurrentFiltersController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class CurrentFiltersObservableController: ObservableObject, CurrentFiltersController {

  /// Currently applied filters with an associated filter group ID
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

  public func remove(_ filter: FilterAndID) {
    onRemoveItem?(filter)
  }

}
#endif
