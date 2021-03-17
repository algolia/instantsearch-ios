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
    
    public init(interactor: DynamicFacetsInteractor, filterState: FilterState) {
      self.interactor = interactor
      self.filterState = filterState
    }
    
    public func connect() {
      filterState.onChange.subscribe(with: interactor) { interactor, filters in
        let attributesWithFacets = filters
          .toFilterGroups()
          .flatMap(\.filters)
          .compactMap { $0 as? FacetFilter }
          .filter { !$0.isNegated }
          .map { (attribute: $0.attribute, value: $0.value.description) }
        interactor.selections = Dictionary(grouping: attributesWithFacets, by: \.attribute).mapValues { Set($0.map(\.value)) }
      }
      interactor.onSelectionsUpdated.subscribePast(with: filterState) { (filterState, selections) in
        selections.forEach { attribute, selections in
          for selection in selections {
            filterState[and: "\(attribute)"].toggle(Filter.Facet(attribute: attribute, stringValue: selection))
          }
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
