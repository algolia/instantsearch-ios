//
//  DynamicFacetsInteractor+FilterState.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

import Foundation

public extension DynamicFacetsInteractor {
  
  /// Connection between a dynamic facets business logic and a filter state
  struct FilterStateConnection: Connection {
    
    /// Dynamic facets business logic
    public let interactor: DynamicFacetsInteractor
    
    ///
    public let filterState: FilterState
    
    ///
    public let groupIDForAttribute: [Attribute: FilterGroup.ID]

    /**
     - parameters:
       - interactor: Dynamic facets business logic
       - filterState:
       - groupIDForAttribute:
     */
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
      whenSelectionsComputedThenUpdateFilterState()
      whenFilterStateChangedThenUpdateSelections()
    }
    
    public func disconnect() {
      filterState.onChange.cancelSubscription(for: interactor)
      interactor.onSelectionsChanged.cancelSubscription(for: filterState)
    }
    
    private func whenSelectionsComputedThenUpdateFilterState() {
      interactor.onSelectionsComputed.subscribePast(with: filterState) { filterState, selectionsPerAttribute in
        selectionsPerAttribute.forEach { attribute, selections in
          let groupID = groupID(for: attribute)
          let filters = selections.map { Filter.Facet(attribute: attribute, stringValue: $0) }
          filterState.removeAll(for: attribute, fromGroupWithID: groupID)
          filterState.addAll(filters: filters, toGroupWithID: groupID)
        }
        filterState.notifyChange()
      }
    }
    
    private func whenFilterStateChangedThenUpdateSelections() {
      filterState.onChange.subscribePast(with: interactor) { interactor, filters in
        let selectionsPerAttribute: [(attribute: Attribute, values: Set<String>)] = interactor
          .orderedFacets
          .map(\.attribute)
          .map { attribute in
            let values = filterState
              .getFilters(forGroupWithID: groupID(for: attribute))
              .compactMap { $0.filter as? FacetFilter }
              .filter { $0.attribute == attribute && !$0.isNegated }
              .map(\.value.description)
            return (attribute, Set(values))
          }
        interactor.selections = Dictionary(uniqueKeysWithValues: selectionsPerAttribute)
      }
    }
    
  }
  
  @discardableResult func connectFilterState(_ filterState: FilterState) -> FilterStateConnection {
    let connection = FilterStateConnection(interactor: self, filterState: filterState)
    connection.connect()
    return connection
  }
  
}
