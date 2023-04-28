//
//  AlgoliaHitsPage.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation

/// `AlgoliaHitsPage` is a generic struct that represents a paginated page of search results from
/// the Algolia search engine, conforming to the `Page` protocol.
///
/// This struct requires the `Item` type to conform to the `Decodable` protocol. It contains
/// information about the current page, items, and navigation (previous and next pages) in the search results.
///
/// Usage:
/// ```
/// let algoliaHitsPage = AlgoliaHitsPage(page: 0,
///                                       hits: [CustomDecodableItem(...)],
///                                       hasPrevious: false,
///                                       hasNext: true)
/// ```
///
/// - Note: The `Item` type parameter represents the type of the items in the page and should conform to the `Decodable` protocol.
public struct AlgoliaHitsPage<Item: Decodable>: Page {

  /// The current page number (zero-based).
  public let page: Int
  
  /// The list of items in the current page.
  public let items: [Item]
  
  /// A Boolean value indicating if there is a previous page in the search results.
  public let hasPrevious: Bool
  
  /// A Boolean value indicating if there is a next page in the search results.
  public let hasNext: Bool
  
  /// Initializes a new `AlgoliaHitsPage` object with the provided page number, items, and navigation flags.
  ///
  /// - Parameters:
  ///   - page: The current page number (zero-based).
  ///   - hits: The list of items in the current page.
  ///   - hasPrevious: A Boolean value indicating if there is a previous page in the search results.
  ///   - hasNext: A Boolean value indicating if there is a next page in the search results.
  init(page: Int,
       hits: [Item],
       hasPrevious: Bool,
       hasNext: Bool) {
    self.page = page
    self.items = hits
    self.hasPrevious = hasPrevious
    self.hasNext = hasNext
  }
  
  /// Determines if the left-hand side page is less than the right-hand side page.
  ///
  /// - Parameters:
  ///   - lhs: The left-hand side `AlgoliaHitsPage`.
  ///   - rhs: The right-hand side `AlgoliaHitsPage`.
  /// - Returns: `true` if the left-hand side page is less than the right-hand side page, `false` otherwise.
  public static func < (lhs: AlgoliaHitsPage, rhs: AlgoliaHitsPage) -> Bool {
    lhs.page < rhs.page
  }
  
  /// Determines if the left-hand side page is equal to the right-hand side page.
  ///
  /// - Parameters:
  ///   - lhs: The left-hand side `AlgoliaHitsPage`.
  ///   - rhs: The right-hand side `AlgoliaHitsPage`.
  /// - Returns: `true` if the left-hand side page is equal to the right-hand side page, `false` otherwise.
  public static func == (lhs: AlgoliaHitsPage, rhs: AlgoliaHitsPage) -> Bool {
    lhs.page == rhs.page
  }
  
}

