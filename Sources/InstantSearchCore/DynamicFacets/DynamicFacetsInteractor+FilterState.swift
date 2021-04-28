//
//  DynamicFacetsInteractor+FilterState.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

import Foundation

public extension DynamicFacetsInteractor {
  
  struct FilterStateConnection: Connection {
    
    public let interactor: DynamicFacetsInteractor
    public let filterState: FilterState
    public let groupIDForAttribute: [Attribute: FilterGroup.ID]

    public init(interactor: DynamicFacetsInteractor,
                filterState: FilterState,
                groupIDForAttribute: [Attribute: FilterGroup.ID] = [:]) {
      self.interactor = interactor
      self.filterState = filterState
      self.groupIDForAttribute = groupIDForAttribute
    }
    
    private func groupID(for attribute: Attribute) -> FilterGroup.ID {
      return groupIDForAttribute[attribute] ?? .and(name: attribute.rawValue)
    }
      
    public func connect() {
      filterState.onChange.subscribe(with: interactor) { interactor, filters in
//        let attributesWithFacets = interactor.facetOrder.map(\.attribute).map(groupID(for:)).map { groupID in
//          filters
//            .filtersContainer
//            .filters
//            .getFilters(forGroupWithID: groupID)
//            .compactMap { $0.filter as? FacetFilter }
//            .filter { !$0.isNegated }
//            .map { (attribute: $0.attribute, value: $0.value.description) }
//        }.flatMap { $0 }
        let attributesWithFacets = filters
          .toFilterGroups()
          .flatMap(\.filters)
          .compactMap { $0 as? FacetFilter }
          .filter { !$0.isNegated }
          .map { (attribute: $0.attribute, value: $0.value.description) }
        interactor.selections = Dictionary(grouping: attributesWithFacets, by: \.attribute)
          .mapValues { Set($0.map(\.value)) }
      }
      interactor.onSelectionsUpdated.subscribePast(with: filterState) { filterState, selections in
        selections
          .map { attribute, selections in selections
          .map { (attribute, $0) } }
          .flatMap { $0 }
          .forEach { attribute, selection in
            let filter = Filter.Facet(attribute: attribute, stringValue: selection)
            filterState.toggle(filter, inGroupWithID: groupID(for: attribute))
        }
      }
    }
    
    public func disconnect() {
      filterState.onChange.cancelSubscription(for: interactor)
      interactor.onSelectionsUpdated.cancelSubscription(for: filterState)
    }
    
  }
  
  @discardableResult func connectFilterState(_ filterState: FilterState) -> FilterStateConnection {
    let connection = FilterStateConnection(interactor: self, filterState: filterState)
    connection.connect()
    return connection
  }
  
}
