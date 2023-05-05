//
//  PageSource.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation

/// `PageSource` is a generic protocol that defines the required interface for a source of paginated data.
/// A custom type conforming to this protocol should be able to fetch an initial page, and fetch pages
/// before and after a given page.
///
/// Usage:
/// ```
/// struct CustomPageSource: PageSource {
///   typealias Page = CustomPage
///
///   func fetchInitialPage() async throws -> CustomPage { ... }
///   func fetchPage(before page: CustomPage) async throws -> CustomPage { ... }
///   func fetchPage(after page: CustomPage) async throws -> CustomPage { ... }
/// }
/// ```
///
/// - Note: The `Page` associated type represent the page of data provided by this source.
@available(iOS 13.0.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol PageSource<Page> {

  /// The associated data type for the items in the pages.
  associatedtype Page

  /// Fetches the initial page of data.
  ///
  /// - Returns: The initial `ItemsPage` containing the data.
  /// - Throws: An error if the fetch operation fails.
  func fetchInitialPage() async throws -> Page

  /// Fetches the page before a given page.
  ///
  /// - Parameter page: The `ItemsPage` before which to fetch the data.
  /// - Returns: The previous `ItemsPage` containing the data.
  /// - Throws: An error if the fetch operation fails.
  func fetchPage(before page: Page) async throws -> Page

  /// Fetches the page after a given page.
  ///
  /// - Parameter page: The `ItemsPage` after which to fetch the data.
  /// - Returns: The next `ItemsPage` containing the data.
  /// - Throws: An error if the fetch operation fails.
  func fetchPage(after page: Page) async throws -> Page

}
