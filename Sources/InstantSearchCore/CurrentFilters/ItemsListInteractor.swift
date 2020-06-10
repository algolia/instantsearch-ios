//
//  ItemsListInteractor.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 12/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class ItemsListInteractor<Item: Hashable> {

  public var items: Set<Item> {
    didSet {
      if oldValue != items {
        onItemsChanged.fire(items)
      }
    }
  }

  public let onItemsChanged: Observer<Set<Item>>
  public let onItemsComputed: Observer<Set<Item>>

  public init(items: Set<Item> = []) {
    self.items = items
    self.onItemsChanged = .init()
    self.onItemsComputed = .init()
  }

  public func remove(item: Item) {
    onItemsComputed.fire(items.subtracting([item]))
  }

  public func add(item: Item) {
    onItemsComputed.fire(items.union([item]))
  }

}
