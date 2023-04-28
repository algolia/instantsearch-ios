//
//  Page.swift
//  
//
//  Created by Vladislav Fitc on 27/04/2023.
//

import Foundation

/// `Page` is a generic protocol that represents a single page of data, usually used in pagination scenarios.
/// It should be implemented by a custom type representing a page of a specific data type.
///
/// Usage:
/// ```
/// struct CustomPage: Page {
///   typealias Item = CustomData
///
///   var hasPrevious: Bool
///   var hasNext: Bool
///   var items: [CustomData]
/// }
/// ```
///
/// - Note: The `Item` associated type represents the type of data contained in the page.
public protocol Page<Item>: Comparable {
  
  /// The associated data type for the items in the page.
  associatedtype Item
    
  /// Indicates whether there is a previous page of data.
  var hasPrevious: Bool { get }
  
  /// Indicates whether there is a next page of data.
  var hasNext: Bool { get }
  
  /// An array of items contained in the page.
  var items: [Item] { get }
  
}
