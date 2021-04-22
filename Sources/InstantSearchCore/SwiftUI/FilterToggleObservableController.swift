//
//  FilterToggleObservableController.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 11/04/2021.
//

import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class FilterToggleObservableController<Filter: FilterType>: ObservableObject, SelectableController {

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

  public func setItem(_ item: Filter) {
  }

  public init(isSelected: Bool) {
    self.isSelected = isSelected
  }

}
