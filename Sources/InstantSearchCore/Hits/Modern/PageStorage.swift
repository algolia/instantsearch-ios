//
//  PageStorage.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation

/// `PageStorage` is a generic actor responsible for storing and managing pages of data.
/// It provides methods for appending, prepending, and clearing pages.
///
/// Usage:
/// ```
/// let pageStorage = PageStorage<CustomPage>()
/// pageStorage.append(somePage)
/// pageStorage.prepend(anotherPage)
/// pageStorage.clear()
/// ```
///
/// - Note: The `Page` type parameter represents the type of the pages to be stored.
@available(iOS 13.0.0, *)
actor PageStorage<Page> {
  
  /// An array containing the stored pages.
  var pages: [Page] = []
  
  /// Appends a given page to the end of the storage.
  ///
  /// - Parameter page: The `Page` to be appended.
  func append(_ page: Page) {
    pages.append(page)
  }
  
  /// Prepends a given page to the beginning of the storage.
  ///
  /// - Parameter page: The `Page` to be prepended.
  func prepend(_ page: Page) {
    pages.insert(page, at: 0)
  }
  
  /// Removes all the pages from the storage.
  func clear() {
    pages.removeAll()
  }

}
