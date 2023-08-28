//
//  PaginatedDataViewModel.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation

/// `PaginatedDataViewModel` is a generic class responsible for handling paginated data from a `PageSource`.
/// It is designed to be used with SwiftUI and is an `ObservableObject` that can be bound to UI elements.
///
/// Usage:
/// ```
/// let source = CustomPageSource()
/// let hits = PaginatedDataViewModel(source: source)
/// ```
///
/// - Note: `ItemsPage` must conform to the `Page` protocol.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public final class PaginatedDataViewModel<ItemsPage: Page>: ObservableObject {

  /// An array of fetched items.
  @Published public var items: [ItemsPage.Item]

  /// Indicates whether the data is being loaded.
  @Published public var isLoading: Bool

  /// Indicates whether there is a previous page of data.
  @Published public var hasPrevious: Bool

  /// Indicates whether there is a next page of data.
  @Published public var hasNext: Bool

  /// The source object that conforms to the `PageSource` protocol.
  let source: any PageSource<ItemsPage>

  /// A `PageStorage` object that stores the fetched pages.
  private let storage: ConcurrentList<ItemsPage>

  /// Initializes a new instance of `InfiniteScrollViewModel` with a given `source` object.
  ///
  /// - Parameter source: The source object that conforms to the `PageSource` protocol.
  public init<PS: PageSource<ItemsPage>>(source: PS) {
    self.source = source
    self.storage = ConcurrentList()
    self.isLoading = false
    self.items = []
    self.hasPrevious = false
    self.hasNext = true
  }

  /// Loads the next page of data.
  public func loadNext() {
    Task {
      let page: ItemsPage
      if let maxPage = await storage.items.last, maxPage.hasNext {
        page = try await source.fetchPage(after: maxPage)
      } else {
        page = try await source.fetchInitialPage()
      }
      await append(page)
    }
  }

  /// Loads the previous page of data.
  public func loadPrevious() {
    Task {
      if let minPage = await storage.items.first, minPage.hasPrevious {
        let page = try await source.fetchPage(before: minPage)
        await prepend(page)
      }
    }
  }

  @MainActor
  private func append(_ page: ItemsPage) async {
    await storage.append(page)
    items = await storage.items.flatMap(\.items)
    hasNext = page.hasNext
  }

  @MainActor
  private func prepend(_ page: ItemsPage) async {
    await storage.prepend(page)
    items = await storage.items.flatMap(\.items)
    hasPrevious = page.hasPrevious
  }

  /// Resets the stored data and pagination states.
  @MainActor
  public func reset() async {
    await storage.clear()
    items = []
    hasPrevious = false
    hasNext = true
  }

}
