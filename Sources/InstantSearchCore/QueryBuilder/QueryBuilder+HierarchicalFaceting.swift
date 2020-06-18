//
//  ComplexQueryBuilder+HierarchicalFaceting.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import AlgoliaSearchClient

extension QueryBuilder {

  func buildHierarchicalQueries(with query: Query,
                                filterGroups: [FilterGroupType],
                                hierarchicalAttributes: [Attribute],
                                hierachicalFilters: [Filter.Facet]) -> [Query] {

    // An empty hierarchical offset in the beggining is added to create
    // The first request in the list returning search results

    guard !hierachicalFilters.isEmpty else {
      return []
    }

    let offsetHierachicalFilters: [Filter.Facet?] = [.none] + hierachicalFilters

    let queriesForHierarchicalFacets = zip(hierarchicalAttributes, offsetHierachicalFilters)
      .map { arguments -> Query in
        let (attribute, hierarchicalFilter) = arguments

        var outputFilterGroups = filterGroups

        if let appliedHierachicalFacet = hierachicalFilters.last {
          outputFilterGroups = outputFilterGroups.map { group in
            guard let andGroup = group as? FilterGroup.And else {
              return group
            }
            let filtersMinusHierarchicalFacet = andGroup.filters.filter { ($0 as? Filter.Facet) != appliedHierachicalFacet }
            return FilterGroup.And(filters: filtersMinusHierarchicalFacet, name: andGroup.name)
          }
        }

        if let currentHierarchicalFilter = hierarchicalFilter {
          outputFilterGroups.append(FilterGroup.And(filters: [currentHierarchicalFilter], name: "_hierarchical"))
        }

        var query = query
        query.requestOnlyFacets()
        query.facets = [attribute]
        query.filters = FilterGroupConverter().sql(outputFilterGroups)
        return query

    }

    return queriesForHierarchicalFacets

  }

}
