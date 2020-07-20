//
//  FilterState+HierarchicalFaceting.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 05/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

extension FilterState: HierarchicalFacetingDelegate {

  private var hierarchicalGroupName: String {
    return "_hierarchical"
  }

  public var hierarchicalFilters: [Filter.Facet] {
    get {
      return self[hierarchical: hierarchicalGroupName].hierarchicalFilters
    }

    set {
      self[hierarchical: hierarchicalGroupName].set(newValue)

    }
  }

  public var hierarchicalAttributes: [Attribute] {
    get {
      return self[hierarchical: hierarchicalGroupName].hierarchicalAttributes
    }

    set {
      self[hierarchical: hierarchicalGroupName].set(newValue)
    }
  }

}
