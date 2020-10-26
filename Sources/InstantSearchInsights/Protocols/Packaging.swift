//
//  Packaging.swift
//  
//
//  Created by Vladislav Fitc on 17/10/2020.
//

import Foundation

protocol Packaging {

  associatedtype Item: Codable

  var packageCapacity: Int { get }

  var packages: [Package<Item>] { get }

  mutating func set(_ packages: [Package<Item>])
  mutating func pack(_ item: Item)
  mutating func remove(_ package: Package<Item>)
}
