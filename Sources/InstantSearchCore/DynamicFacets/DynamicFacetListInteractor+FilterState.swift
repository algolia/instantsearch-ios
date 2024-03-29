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

    /// Type of filter group created by default for a facet attribute. Default value is `and`
    public let defaultFilterGroupType: RefinementOperator

    /**
     - parameters:
       - interactor: Dynamic facet list business logic
       - filterState: FilterState that holds your filters
       - filterGroupForAttribute: Mapping between a facet attribute and a descriptor of a filter group where the corresponding facet filters stored in the filter state.
       - defaultFilterGroupType: Type of filter group created by default for a facet attribute. Default value is `and`.

     If no filter group descriptor provided, the filters for attribute will be automatically stored in the group of `defaultFilterGroupType` with the facet attribute name.
     */
    public init(interactor: DynamicFacetListInteractor,
                filterState: FilterState,
                filterGroupForAttribute: [Attribute: FilterGroupDescriptor] = [:],
                defaultFilterGroupType: RefinementOperator = .and) {
      self.interactor = interactor
      self.filterState = filterState
      self.filterGroupForAttribute = filterGroupForAttribute
      self.defaultFilterGroupType = defaultFilterGroupType
    }

    public func connect() {
      whenSelectionsComputedThenUpdateFilterState()
      whenFilterStateChangedThenUpdateSelections()
      whenFacetOrderChangedThenUpdateSelections()
    }

    public func disconnect() {
      filterState.onChange.cancelSubscription(for: interactor)
      interactor.onSelectionsChanged.cancelSubscription(for: filterState)
      interactor.onFacetOrderChanged.cancelSubscription(for: filterState)
    }

    private func groupID(for attribute: Attribute) -> FilterGroup.ID {
      let (groupName, refinementOperator) = filterGroupForAttribute[attribute] ?? (attribute.rawValue, defaultFilterGroupType)
      switch refinementOperator {
      case .or:
        return .or(name: groupName, filterType: .facet)
      case .and:
        return .and(name: groupName)
      }
    }

    private func calculateSelections(facets: [AttributedFacets], filterState: FilterState) -> [Attribute: Set<String>] {
      let selectionsPerAttribute: [(attribute: Attribute, values: Set<String>)] =
        facets
        .map(\.attribute)
        .map { attribute in
          let values = filterState
            .getFilters(forGroupWithID: groupID(for: attribute))
            .compactMap { $0.filter as? FacetFilter }
            .filter { $0.attribute == attribute && !$0.isNegated }
            .map(\.value.description)
          return (attribute, Set(values))
        }
      return Dictionary(uniqueKeysWithValues: selectionsPerAttribute)
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

    private func whenFacetOrderChangedThenUpdateSelections() {
      interactor.onFacetOrderChanged.subscribePast(with: filterState) { filterState, orderedFacets in
        interactor.selections = calculateSelections(facets: orderedFacets,
                                                    filterState: filterState)
      }
    }

    private func whenFilterStateChangedThenUpdateSelections() {
      filterState.onChange.subscribePast(with: interactor) { [weak filterState] interactor, _ in
        guard let filterState else { return }
        interactor.selections = calculateSelections(facets: interactor.orderedFacets,
                                                    filterState: filterState)
      }
    }
  }

  /**
   Establishes connection with a FilterState
   - parameter filterState: filter state to connect
   - parameter filterGroupForAttribute: Mapping between a facet attribute and a descriptor of a filter group where the corresponding facet filters stored in the filter state.
   - parameter defaultFilterGroupType: Type of filter group created by default for a facet attribute. Default value is `and`.

   If no filter group descriptor provided, the filters for attribute will be automatically stored in the group of `defaultFilterGroupType` with the facet attribute name.
   */
  @discardableResult func connectFilterState(_ filterState: FilterState,
                                             filterGroupForAttribute: [Attribute: FilterGroupDescriptor] = [:], defaultFilterGroupType: RefinementOperator = .and) -> FilterStateConnection {
    let connection = FilterStateConnection(interactor: self,
                                           filterState: filterState,
                                           filterGroupForAttribute: filterGroupForAttribute,
                                           defaultFilterGroupType: defaultFilterGroupType)
    connection.connect()
    return connection
  }
}
