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
  let creationDate: Date

  var isFull: Bool {
    return items.count == capacity
  }

  init(capacity: Int) {
    id = UUID().uuidString
    items = []
    self.capacity = capacity
    creationDate = Date()
  }

  init(item: Item, capacity: Int) {
    id = UUID().uuidString
    items = [item]
    self.capacity = capacity
    creationDate = Date()
  }

  init(items: [Item], capacity: Int) throws {
    guard items.count <= capacity else {
      throw Error.packageOverflow(capacity: capacity)
    }
    id = UUID().uuidString
    self.items = items
    self.capacity = capacity
    creationDate = Date()
  }

  private init(items: [Item], capacity: Int, creationDate: Date) {
    id = UUID().uuidString
    self.items = items
    self.capacity = capacity
    self.creationDate = creationDate
  }

  func appending(_ item: Item) throws -> Package {
    return try appending([item])
  }

  func appending(_ items: [Item]) throws -> Package {
    guard items.count + self.items.count <= capacity else {
      throw Error.packageOverflow(capacity: capacity)
    }
    return Package(items: self.items + items, capacity: capacity, creationDate: creationDate)
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

  subscript(index: Index) -> Element { return items[index] }
}

extension Package {
  enum Error: Swift.Error, Equatable {
    case packageOverflow(capacity: Int)
  }
}

extension Package.Error: LocalizedError {
  var errorDescription: String? {
    switch self {
    case let .packageOverflow(capacity):
      return "Max items count in package is \(capacity)"
    }
  }
}

extension Package: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case items
    case capacity
    case creationDate
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    items = try container.decode([Item].self, forKey: .items)
    capacity = try container.decode(Int.self, forKey: .capacity)
    // Packages stored by previous versions carry no creation date, consider them created at load time
    creationDate = try container.decodeIfPresent(Date.self, forKey: .creationDate) ?? Date()
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(items, forKey: .items)
    try container.encode(capacity, forKey: .capacity)
    try container.encode(creationDate, forKey: .creationDate)
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
