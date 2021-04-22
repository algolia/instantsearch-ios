//
//  FacetListObservableController.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public class FacetListObservableController: ObservableObject, FacetListController {

  @Published public var facets: [Facet]
  @Published public var selections: Set<String>

  public var onClick: ((Facet) -> Void)?

  public func select(_ facet: Facet) {
    onClick?(facet)
  }

  public func isSelected(_ facet: Facet) -> Bool {
    return selections.contains(facet.value)
  }

  public func setSelectableItems(selectableItems: [SelectableItem<Facet>]) {
    self.facets = selectableItems.map(\.item)
    self.selections = Set(selectableItems.filter(\.isSelected).map(\.item.value))
  }

  public func reload() {
    objectWillChange.send()
  }

  public init(facets: [Facet] = [],
              selections: Set<String> = [],
              onClick: ((Facet) -> Void)? = nil) {
    self.facets = facets
    self.selections = selections
    self.onClick = onClick
  }

}
