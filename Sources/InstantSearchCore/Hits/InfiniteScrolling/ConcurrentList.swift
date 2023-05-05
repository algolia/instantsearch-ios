//
//  PageStorage.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation

/// `ConcurrentList` is a generic actor responsible for storing and managing items.
/// It provides methods for appending, prepending, and clearing items.
///
/// Usage:
/// ```
/// let list = ConcurrentList<String>()
/// list.append("some string")
/// list.prepend("another string")
/// list.clear()
/// ```
///
/// - Note: The `Page` type parameter represents the type of the pages to be stored.
@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
actor ConcurrentList<Item> {

  /// An array containing the stored items.
  var items: [Item] = []

  /// Appends a given item to the end of the storage.
  ///
  /// - Parameter item: The `Item` to be appended.
  func append(_ item: Item) {
    items.append(item)
  }
  /// Prepends a given item to the beginning of the storage.
  ///
  /// - Parameter page: The `Item` to be prepended.
  func prepend(_ item: Item) {
    items.insert(item, at: 0)
  }
  /// Removes all the items from the storage.
  func clear() {
    items.removeAll()
  }

}
