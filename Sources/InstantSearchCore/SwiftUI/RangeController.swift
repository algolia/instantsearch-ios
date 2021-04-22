//
//  PriceController.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 21/04/2021.
//

import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class RangeController: ObservableObject, NumberRangeController {
    
  @Published public var range: ClosedRange<Int> {
    didSet {
      if oldValue != range {
        onRangeChanged?(range)
      }
    }
  }
  
  @Published public var bounds: ClosedRange<Int>
  
  public var onRangeChanged: ((ClosedRange<Int>) -> Void)?
    
  public func setItem(_ item: ClosedRange<Int>) {
  }
  
  public func invalidate() {
  }
  
  private var isInitialBoundsSet: Bool = true
  
  public func setBounds(_ bounds: ClosedRange<Int>) {
    self.bounds = bounds
    if isInitialBoundsSet {
      isInitialBoundsSet = false
      self.range = bounds
    }
  }
  
  public init(range: ClosedRange<Int>,
              bounds: ClosedRange<Int>) {
    self.range = range
    self.bounds = bounds
  }
  
}
