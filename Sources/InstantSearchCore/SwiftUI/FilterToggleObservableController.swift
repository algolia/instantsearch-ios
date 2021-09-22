//
//  FilterToggleObservableController.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 11/04/2021.
//

import Foundation
#if canImport(Combine) && canImport(SwiftUI) && (arch(arm64) || arch(x86_64))
import Combine
import SwiftUI

/// SelectableController implementation adapted for usage with SwiftUI views
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class FilterToggleObservableController<Filter: FilterType>: ObservableObject, SelectableController {

  /// The filter to toggle
  @Published public var filter: Filter?

  /// The state of the filter
  @Published public var isSelected: Bool {
    didSet {
      if oldValue != isSelected {
        onClick?(isSelected)
      }
    }
  }

  public var onClick: ((Bool) -> Void)?

  public func setSelected(_ isSelected: Bool) {
    self.isSelected = isSelected
  }

  public func setItem(_ filter: Filter) {
    self.filter = filter
  }

  public init(filter: Filter? = nil, isSelected: Bool = false) {
    self.filter = filter
    self.isSelected = isSelected
  }

}
#endif
