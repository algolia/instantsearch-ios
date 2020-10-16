//
//  ItemsListInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 12/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Business logic for a list of items
public class ItemsListInteractor<Item: Hashable> {

  /// Items contained in the list
  public var items: Set<Item> {
    didSet {
      if oldValue != items {
        onItemsChanged.fire(items)
      }
    }
  }

  /// Event triggered when items list has been changed externally
  public let onItemsChanged: Observer<Set<Item>>

  /// Event triggered when items list has been changed by business logic
  public let onItemsComputed: Observer<Set<Item>>

  public init(items: Set<Item> = []) {
    self.items = items
    self.onItemsChanged = .init()
    self.onItemsComputed = .init()
  }
  /// Remove an item from list
  /// - Parameter item: item to remove
  public func remove(item: Item) {
    onItemsComputed.fire(items.subtracting([item]))
  }

  /// Add an item to list
  /// - Parameter item: item to add
  public func add(item: Item) {
    onItemsComputed.fire(items.union([item]))
  }

}
