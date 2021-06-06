//
//  DynamicFacetsController.swift
//  
//
//  Created by Vladislav Fitc on 04/06/2021.
//

import Foundation

/**
 Controller presenting the ordered list of facets and handling user interaction
 */
public protocol DynamicFacetsController: AnyObject {

  /// Update the list of attributed facets
  func setFacetOrder(_ facetOrder: [AttributedFacets])
  
  /// Update the facet selections
  func setSelections(_ selections: [Attribute: Set<String>])

  /// A closure to trigger when user selects a facet
  var didSelect: ((Attribute, Facet) -> Void)? { get set }

}
