//
//  PageMap.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 13/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

struct PageMap<Item> {
  typealias PageIndex = Int

  private var storage: [PageIndex: [Item]]

  var pageSize: Int

  var latestPageIndex: PageIndex? {
    return loadedPageIndexes.max()
  }

  var loadedPageIndexes: Set<PageIndex> = []

  var loadedPages: [Page] {
    return storage
      .sorted { $0.key < $1.key }
      .map { Page(index: $0.key, items: $0.value) }
  }

  var loadedPagesCount: Int {
    return storage.count
  }

  var totalPagesCount: Int {
    guard let latestPageIndex = latestPageIndex else { return 0 }
    return latestPageIndex + 1
  }

  mutating func insert(_ page: [Item], withIndex pageIndex: PageIndex) {
    storage[pageIndex] = page
    loadedPageIndexes = Set(storage.keys)
  }

  func page(atIndex pageIndex: PageIndex) -> Page? {
    if let items = storage[pageIndex] {
      return Page(index: pageIndex, items: items)
    } else {
      return nil
    }
  }

  func inserting(_ page: [Item], withIndex pageIndex: PageIndex) -> PageMap {
    var mutableCopy = self
    mutableCopy.insert(page, withIndex: pageIndex)
    return mutableCopy
  }

  func pageIndex(for index: Index) -> PageIndex {
    return index / pageSize
  }

  func containsPage(atIndex pageIndex: PageIndex) -> Bool {
    return storage[pageIndex] != nil
  }

  func containsItem(atIndex index: Index) -> Bool {
    return item(atIndex: index) != nil
  }

  func item(atIndex index: Index) -> Item? {
    let pageIndex = self.pageIndex(for: index)
    let offset = index % pageSize

    guard
      let page = storage[pageIndex],
      offset < page.count else { return nil }

    return page[offset]
  }
}

// MARK: CollectionType

extension PageMap: BidirectionalCollection {
  public typealias Index = Int

  public var startIndex: Index { return 0 }
  public var endIndex: Index {
    guard let latestPageIndex = latestPageIndex else { return 0 }
    // Here we suppose that last items page can be not full
    // So there is a need to calculate a number of elements
    // On last page and add it to previous pages count * page size
    let fullPagesCount = totalPagesCount - 1
    let latestPageItemsCount = storage[latestPageIndex]?.count ?? 0
    return fullPagesCount * pageSize + latestPageItemsCount
  }

  public func index(after index: Index) -> Index {
    return index + 1
  }

  public func index(before index: Index) -> Index {
    return index - 1
  }

  /// Accesses and sets elements for a given flat index position.
  /// Currently, setter can only be used to replace non-optional values.
  public subscript(position: Index) -> Item? {
    get {
      let pageIndex = self.pageIndex(for: position)
      let inPageIndex = position % pageSize
      if let page = storage[pageIndex], inPageIndex < page.count {
        return page[inPageIndex]
      } else {
        // Return nil for all pages that haven't been set yet
        return nil
      }
    }

    set(newValue) {
      guard let newValue = newValue else { return }

      let pageIndex = self.pageIndex(for: position)
      var elementPage = storage[pageIndex]
      elementPage?[position % pageSize] = newValue
      storage[pageIndex] = elementPage
    }
  }
}

protocol Pageable {
  associatedtype Item

  var index: Int { get }
  var items: [Item] { get }
}

extension PageMap {
  struct Page {
    let index: Int
    let items: [Item]

    init(index: Int, items: [Item]) {
      self.index = index
      self.items = items
    }
  }
}

extension PageMap.Page: Equatable where Item: Hashable {}
extension PageMap.Page: Hashable where Item: Hashable {}

extension PageMap {
  init?<T: Pageable>(_ source: T) where T.Item == Item {
    guard !source.items.isEmpty else {
      return nil
    }
    storage = [source.index: source.items]
    loadedPageIndexes = [source.index]
    pageSize = source.items.count
  }

  init?<C: Collection>(_ items: C) where C.Element == Item {
    guard !items.isEmpty else {
      return nil
    }
    let itemsArray = Array(items)
    storage = [0: itemsArray]
    loadedPageIndexes = [0]
    pageSize = itemsArray.count
  }

  init?(_ dictionary: [Int: [Item]]) {
    if dictionary.isEmpty {
      return nil
    }

    storage = dictionary
    loadedPageIndexes = Set(dictionary.keys)
    pageSize = dictionary.sorted(by: { $0.key < $1.key }).first?.value.count ?? 0
  }
}

extension PageMap {
  mutating func cleanUp(basePageIndex pageIndex: Int, keepingPagesOffset: Int) {
    let leastPageIndex = pageIndex - keepingPagesOffset
    let lastPageIndex = pageIndex + keepingPagesOffset

    let pagesToRemove = loadedPageIndexes.filter { $0 < leastPageIndex || $0 > lastPageIndex }

    guard !pagesToRemove.isEmpty else { return }
    InstantSearchCoreLog.trace("InfiniteScrolling: clean pages: \(pagesToRemove.map(String.init).joined(separator: ", "))")

    for pageIndex in pagesToRemove {
      storage.removeValue(forKey: pageIndex)
    }
  }
}
