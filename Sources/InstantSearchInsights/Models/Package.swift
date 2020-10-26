//
//  Package.swift
//  Insights
//
//  Created by Vladislav Fitc on 02/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

struct Package<Item: Codable> {

  let id: String
  let items: [Item]
  let capacity: Int

  var isFull: Bool {
    return items.count == capacity
  }

  init(capacity: Int) {
    self.id = UUID().uuidString
    self.items = []
    self.capacity = capacity
  }

  init(item: Item, capacity: Int) {
    self.id = UUID().uuidString
    self.items = [item]
    self.capacity = capacity
  }

  init(items: [Item], capacity: Int) throws {
    guard items.count <= capacity else {
      throw Error.packageOverflow(capacity: capacity)
    }
    self.id = UUID().uuidString
    self.items = items
    self.capacity = capacity
  }

  func appending(_ item: Item) throws -> Package {
    return try appending([item])
  }

  func appending(_ items: [Item]) throws -> Package {
    guard items.count + self.items.count <= capacity else {
      throw Error.packageOverflow(capacity: capacity)
    }
    return try Package(items: self.items + items, capacity: capacity)
  }

}

extension Package: Collection {

  typealias Index = Array<Item>.Index
  typealias Element = Array<Item>.Element

  var startIndex: Index {
    return items.startIndex
  }

  var endIndex: Index {
    return items.endIndex
  }

  func index(after index: Index) -> Index {
    return items.index(after: index)
  }

  subscript(index: Index) -> Element {
    get { return items[index] }
  }

}

extension Package {

  enum Error: Swift.Error, Equatable {
    case packageOverflow(capacity: Int)
  }

}

extension Package.Error: LocalizedError {

  var errorDescription: String? {
    switch self {
    case .packageOverflow(let capacity):
      return "Max items count in package is \(capacity)"
    }
  }

}

extension Package: Codable {

  enum CodingKeys: String, CodingKey {
    case id
    case items
    case capacity
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.items = try container.decode([Item].self, forKey: .items)
    self.capacity = try container.decode(Int.self, forKey: .capacity)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(items, forKey: .items)
    try container.encode(capacity, forKey: .capacity)
  }

}

extension Package: Hashable {

  static func == (lhs: Package, rhs: Package) -> Bool {
    return lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
