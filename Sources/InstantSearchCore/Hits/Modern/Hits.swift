//
//  Hits.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation
import Combine

/// `Hits` is a generic class responsible for handling paginated data from a `PageSource`.
/// It is designed to be used with SwiftUI and is an `ObservableObject` that can be bound to UI elements.
///
/// Usage:
/// ```
/// let source = CustomPageSource()
/// let hits = Hits(source: source)
/// ```
///
/// - Note: `Source` must conform to the `PageSource` protocol.
@available(iOS 13.0, macOS 10.15, *)
public final class Hits<Source: PageSource>: ObservableObject {
  
  /// An array of fetched items.
  @Published public var hits: [Source.Item]
  
  /// Indicates whether the data is being loaded.
  @Published public var isLoading: Bool
  
  /// Indicates whether there is a previous page of data.
  @Published public var hasPrevious: Bool
  
  /// Indicates whether there is a next page of data.
  @Published public var hasNext: Bool
  
  /// The source object that conforms to the `PageSource` protocol.
  let source: Source
  
  /// A `PageStorage` object that stores the fetched pages.
  private let pageStorage: PageStorage<Source.ItemsPage>
  
  /// Initializes a new instance of `Hits` with a given `source` object.
  ///
  /// - Parameter source: The source object that conforms to the `PageSource` protocol.
  public init(source: Source) {
    self.source = source
    self.pageStorage = PageStorage()
    self.isLoading = false
    self.hits = []
    self.hasPrevious = false
    self.hasNext = true
  }
  
  /// Loads the next page of data.
  public func loadNext() {
    Task { @MainActor in
      let page: Source.ItemsPage
      if let maxPage = await pageStorage.pages.last, maxPage.hasNext {
        page = try await source.fetchPage(after: maxPage)
      } else {
        page = try await source.fetchInitialPage()
      }
      await pageStorage.append(page)
      hits = await pageStorage.pages.flatMap(\.items)
      hasNext = page.hasNext
    }
  }
  
  /// Loads the previous page of data.
  public func loadPrevious() {
    Task { @MainActor in
      if let minPage = await pageStorage.pages.first, minPage.hasPrevious {
        let page = try await source.fetchPage(before: minPage)
        await pageStorage.prepend(page)
        hits = await pageStorage.pages.flatMap(\.items)
        hasPrevious = page.hasPrevious
      }
    }
  }
  
  /// Resets the stored data and pagination states.
  @MainActor
  public func reset() async {
    await pageStorage.clear()
    hits = []
    hasPrevious = false
    hasNext = true
  }

  /// An enumeration of possible errors that can occur while working with `Hits`.
  public enum Error: LocalizedError {
    /// Indicates an attempt to access a hit on an unaccessible page.
    case indexOutOfRange
    
    /// Indicates an error occurred during a search request.
    case requestError(Swift.Error)
    
    /// A localized description of the error.
    public var errorDescription: String? {
      switch self {
      case .requestError(let error):
        return "Error occured during search request: \(error)"
      case .indexOutOfRange:
        return "Attempt to access the hit on unaccessible page"
      }
    }
  }
  
}
