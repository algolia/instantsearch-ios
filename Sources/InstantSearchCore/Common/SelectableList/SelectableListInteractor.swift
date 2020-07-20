//
//  SelectableListInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 18/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public enum SelectionMode {
  case single
  case multiple
}

public class SelectableListInteractor<Key: Hashable, Item: Equatable> {

  public var items: [Item] {
    didSet {
      if oldValue != items {
        onItemsChanged.fire(items)
      }
    }
  }

  public var selections: Set<Key> {
    didSet {
      if oldValue != selections {
        onSelectionsChanged.fire(selections)
      }
    }
  }

  public let onItemsChanged: Observer<[Item]>
  public let onSelectionsChanged: Observer<Set<Key>>
  public let onSelectionsComputed: Observer<Set<Key>>

  public let selectionMode: SelectionMode

  public init(items: [Item] = [], selectionMode: SelectionMode) {
    self.items = items
    self.selections = []
    self.onItemsChanged = .init()
    self.onSelectionsChanged = .init()
    self.onSelectionsComputed = .init()
    self.selectionMode = selectionMode
  }

  public func computeSelections(selectingItemForKey key: Key) {

    let computedSelections: Set<Key>

    switch (selectionMode, selections.contains(key)) {
    case (.single, true):
      computedSelections = []

    case (.single, false):
      computedSelections = [key]

    case (.multiple, true):
      computedSelections = selections.subtracting([key])

    case (.multiple, false):
      computedSelections = selections.union([key])
    }

    onSelectionsComputed.fire(computedSelections)

  }

}
