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
        let s: [(attribute: Attribute, values: [String])] = interactor
          .facetOrder
          .map(\.attribute)
          .map { attribute in
            let values = filterState
              .getFilters(forGroupWithID: groupID(for: attribute))
              .compactMap { $0.filter as? FacetFilter }
              .filter { $0.attribute == attribute && !$0.isNegated }
              .map(\.value.description)
            return (attribute, values)
          }
        interactor.selections = Dictionary(uniqueKeysWithValues: s).mapValues(Set.init)
      }
      
      interactor.onSelectionsUpdated.subscribePast(with: filterState) { filterState, selections in
        selections.forEach { attribute, selection in
          let groupID = groupID(for: attribute)
          filterState.removeAll(for: attribute, fromGroupWithID: groupID)
          let filters = selection.map { Filter.Facet(attribute: attribute, stringValue: $0) }
          filterState.addAll(filters: filters, toGroupWithID: groupID)
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
