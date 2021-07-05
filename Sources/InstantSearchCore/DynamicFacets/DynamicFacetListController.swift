//
//  DynamicFacetListController.swift
//  
//
//  Created by Vladislav Fitc on 04/06/2021.
//

import Foundation

/**
 Controller presenting the ordered list of facets and handling the user interaction
 */
public protocol DynamicFacetListController: AnyObject {

  /// Update the list of the ordered attributed facets
  func setOrderedFacets(_ orderedFacets: [AttributedFacets])

  /// Update the facets selections
  func setSelections(_ selections: [Attribute: Set<String>])

  /// A closure to trigger when user selects a facet
  var didSelect: ((Attribute, Facet) -> Void)? { get set }

}
