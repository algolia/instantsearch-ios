//
//  DynamicFacetListInteractor.swift
//  
//
//  Created by Vladislav Fitc on 16/03/2021.
//

import Foundation

/**
  Dynamic facets business logic.
 
  Consists of:
  - Properties representing the current facets state
  - Set of events triggered when the state changes.
  - Convenient functions to toggle and fetch the selection state of facet values
 */
public class DynamicFacetListInteractor {

  public typealias SelectionsPerAttribute = [Attribute: Set<String>]

  /// Ordered list of attributed facets
  public var orderedFacets: [AttributedFacets] = .init() {
    didSet {
      onFacetOrderChanged.fire(orderedFacets)
      updateInteractors()
    }
  }

  /// Mapping between a facet attribute and a set of selected facet values
  public var selections: SelectionsPerAttribute = .init() {
    didSet {
      guard oldValue != selections else { return }
      onSelectionsChanged.fire(selections)
    }
  }

  /// Event triggered when the facet order changed externally
  public let onFacetOrderChanged: Observer<[AttributedFacets]>

  /// Event triggered when the facets values selection changed externally
  public let onSelectionsChanged: Observer<SelectionsPerAttribute>

  /// Event triggered when the facets values selection changed by the business logic
  public let onSelectionsComputed: Observer<SelectionsPerAttribute>

  /// Mapping between a facet attribute and a facet values selection mode
  /// If not provided, the default selection mode is `.single`
  public let selectionModeForAttribute: [Attribute: SelectionMode]

  /// Storage for selectable facet list logic per attribute
  private var facetListPerAttribute: [Attribute: SelectableListInteractor<String, Facet>]

  /**
   - Parameters:
     - orderedFacets: Ordered list of attributed facets
     - selections: Mapping between a facet attribute and a set of selected  facet values
     - selectionModeForAttribute: Mapping between a facet attribute and a facet values selection mode. If not provided, the default selection mode is .single.
  */
  public init(orderedFacets: [AttributedFacets] = [],
              selections: [Attribute: Set<String>] = [:],
              selectionModeForAttribute: [Attribute: SelectionMode] = [:]) {
    self.orderedFacets = orderedFacets
    self.selections = selections
    self.onFacetOrderChanged = .init()
    self.onSelectionsChanged = .init()
    self.onSelectionsComputed = .init()
    self.selectionModeForAttribute = selectionModeForAttribute
    self.facetListPerAttribute = [:]
    onFacetOrderChanged.fire(orderedFacets)
    onSelectionsChanged.fire(selections)
    updateInteractors()
    Telemetry.shared.trace(type: .dynamicFacets,
                           parameters: [
                            orderedFacets.isEmpty ? nil : .orderedFacets,
                            selections.isEmpty ? nil : .selections,
                            selectionModeForAttribute.isEmpty ? nil : .selectionModeForAttribute
                           ])
  }

  /**
    Returns a selection state of facet value for attribute
     - parameters:
       - facetValue: the facet value
       - attribute: the facet attribute
  */
  public func isSelected(facetValue: String,
                         for attribute: Attribute) -> Bool {
    return selections[attribute]?.contains(facetValue) ?? false
  }

  /**
    Toggle the selection state of facet value for attribute
     - parameters:
       - facetValue: the facet value
       - attribute: the facet attribute
  */
  public func toggleSelection(ofFacetValue facetValue: String,
                              for attribute: Attribute) {
    facetListPerAttribute[attribute]?.computeSelections(selectingItemForKey: facetValue)
  }

  private func updateInteractors() {

    for attributedFacet in orderedFacets {
      let attribute = attributedFacet.attribute

      let facetList: SelectableListInteractor<String, Facet>

      if let existingFacetList = facetListPerAttribute[attribute] {
        facetList = existingFacetList
      } else {
        facetList = createFacetList(for: attribute)
        facetListPerAttribute[attribute] = facetList
      }

      facetList.items = attributedFacet.facets
      facetList.selections = selections[attribute] ?? []

    }

  }

  private func createFacetList(for attribute: Attribute) -> SelectableListInteractor<String, Facet> {

    let selectionMode = selectionModeForAttribute[attribute] ?? .single
    let facetList = SelectableListInteractor<String, Facet>(selectionMode: selectionMode)

    facetList.onSelectionsComputed.subscribe(with: self) { interactor, selections in
      var currentSelections = interactor.selections
      currentSelections[attribute] = selections
      interactor.onSelectionsComputed.fire(currentSelections)
    }

    onSelectionsChanged.subscribe(with: facetList) { facetList, selections in
      facetList.selections = selections[attribute] ?? []
    }

    return facetList
  }

}
