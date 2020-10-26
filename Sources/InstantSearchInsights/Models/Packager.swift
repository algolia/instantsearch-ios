//
//  Packager.swift
//  
//
//  Created by Vladislav Fitc on 17/10/2020.
//

import Foundation

struct Packager<Item: Codable>: Packaging {

  private(set) var packages: [Package<Item>]

  let packageCapacity: Int

  init(packages: [Package<Item>] = [], packageCapacity: Int) {
    self.packages = packages
    self.packageCapacity = packageCapacity
  }

  mutating func set(_ packages: [Package<Item>]) {
    self.packages = packages
  }

  mutating func pack(_ item: Item) {
    let package: Package<Item>

    if let lastPackage = packages.last, !lastPackage.isFull {
      package = (try? packages.removeLast().appending(item)) ?? Package(item: item, capacity: packageCapacity)
    } else {
      package = Package(item: item, capacity: packageCapacity)
    }

    packages.append(package)
  }

  mutating func remove(_ package: Package<Item>) {
    packages.removeAll(where: { package.id == $0.id })
  }

}
