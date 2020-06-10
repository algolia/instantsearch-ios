//
//  PageCoordinator.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 04/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

class SynchronizedSet<T: Hashable> {

  private let queue = DispatchQueue(label: "thread_safe_access_queue", attributes: .concurrent)
  private var storage: Set<T> = []

  func contains(_ item: T) -> Bool {
    var containsItem: Bool!
    queue.sync {
      containsItem = self.storage.contains(item)
    }
    return containsItem
  }

  func insert(_ item: T) {
    queue.async(flags: .barrier) {
      self.storage.insert(item)
    }
  }

  func remove(_ item: T) {
    queue.async(flags: .barrier) {
      self.storage.remove(item)
    }
  }

  func removeAll() {
    queue.async(flags: .barrier) {
      self.storage.removeAll()
    }
  }

}
