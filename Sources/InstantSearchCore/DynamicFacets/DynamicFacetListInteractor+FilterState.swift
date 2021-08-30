//
//  DynamicFacetListInteractor+FilterState.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

import Foundation

public extension DynamicFacetListInteractor {

  /// Connection between a dynamic facets business logic and a filter state
  struct FilterStateConnection: Connection {

    /// Dynamic facets business logic
    public let interactor: DynamicFacetListInteractor

    /// FilterState that holds your filters
    public let filterState: FilterState

    /// Mapping between a facet attribute and a descriptor of a filter group where the corresponding facet filters stored in the filter state.
    ///
    /// If no filter group descriptor provided, the filters for attribute will be automatically stored in the conjunctive (`and`)  group with the facet attribute name.
    public let filterGroupForAttribute: [Attribute: FilterGroupDescriptor]

    /**
     - parameters:
       - interactor: Dynamic facet list business logic
       - filterState: FilterState that holds your filters
       - filterGroupForAttribute: Mapping between a facet attribute and a descriptor of a filter group where the corresponding facet filters stored in the filter state.
                                  
     If no filter group descriptor provided, the filters for attribute will be automatically stored in the conjunctive (`and`)  group with the facet attribute name`.
     */
    public init(interactor: DynamicFacetListInteractor,
                filterState: FilterState,
                filterGroupForAttribute: [Attribute: FilterGroupDescriptor] = [:]) {
      self.interactor = interactor
      self.filterState = filterState
      self.filterGroupForAttribute = filterGroupForAttribute
    }

    public func connect() {
      whenSelectionsComputedThenUpdateFilterState()
      whenFilterStateChangedThenUpdateSelections()
    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: interactor)
      interactor.onSelectionsChanged.cancelSubscription(for: filterState)
    }

    private func groupID(for attribute: Attribute) -> FilterGroup.ID {
      let (groupName, refinementOperator) = filterGroupForAttribute[attribute] ?? (attribute.rawValue, .and)
      switch refinementOperator {
      case .or:
        return .or(name: groupName, filterType: .facet)
      case .and:
        return .and(name: groupName)
      }
    }

    private func whenSelectionsComputedThenUpdateFilterState() {
      interactor.onSelectionsComputed.subscribePast(with: filterState) { filterState, selectionsPerAttribute in
        selectionsPerAttribute.forEach { attribute, selections in
          let groupID = self.groupID(for: attribute)
          let filters = selections.map { Filter.Facet(attribute: attribute, stringValue: $0) }
          filterState.removeAll(for: attribute, fromGroupWithID: groupID)
          filterState.addAll(filters: filters, toGroupWithID: groupID)
        }
        filterState.notifyChange()
      }
    }

    private func whenFilterStateChangedThenUpdateSelections() {
      filterState.onChange.subscribePast(with: interactor) { interactor, _ in
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

  /**
   Establishes connection with a FilterState
   - parameter filterState: filter state to connect
   - parameter filterGroupForAttribute: Mapping between a facet attribute and a descriptor of a filter group where the corresponding facet filters stored in the filter state.
   
   If no filter group descriptor provided, the filters for attribute will be automatically stored in the conjunctive (`and`)  group with the facet attribute name.
   */
  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             filterGroupForAttribute: [Attribute: FilterGroupDescriptor] = [:]) -> FilterStateConnection {
    let connection = FilterStateConnection(interactor: self,
                                           filterState: filterState,
                                           filterGroupForAttribute: filterGroupForAttribute)
    connection.connect()
    return connection
  }

}
