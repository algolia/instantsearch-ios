//
//  DynamicFacetsController.swift
//  
//
//  Created by Vladislav Fitc on 04/06/2021.
//

import Foundation

/**
 Controller presenting the ordered list of facets
 */
public protocol DynamicFacetsController: AnyObject {
  
  func apply(_ facetOrder: [AttributedFacets])
  func apply(_ selections: [Attribute: Set<String>])
  
  var didSelect: ((Attribute, Facet) -> Void)? { get set }
  
}
