//
//  AttributedFacets.swift
//  
//
//  Created by Vladislav Fitc on 17/03/2021.
//

import Foundation

/// List of ordered facets with their attribute.
public struct AttributedFacets: Codable {

  /// Facet attribute
  public let attribute: Attribute

  /// List of ordered facet values
  public let facets: [Facet]

  enum CodingKeys: String, CodingKey {
    case attribute
    case facets = "values"
  }

  /**
   - parameters:
     - attribute: Facet attribute
     - facets: List of ordered facet values
  */
  public init(attribute: Attribute,
              facets: [Facet] = []) {
    self.attribute = attribute
    self.facets = facets
  }

}
