//
//  HierarchicalObservableController.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 21/04/2021.
//

import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class HierarchicalObservableController: ObservableObject, HierarchicalController {
      
  @Published public var items: [HierarchicalFacet]
  
  public var onClick: ((String) -> Void)?
  
  public func setItem(_ facets: [HierarchicalFacet]) {
    self.items = facets
  }
  
  public func select(_ facetValue: String) {
    onClick?(facetValue)
  }
  
  public init(items: [HierarchicalFacet] = []) {
    self.items = items
  }
    
}
