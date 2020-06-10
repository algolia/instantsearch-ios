//
//  ItemInteractor.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 31/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class ItemInteractor<Item> {

  public var item: Item {
    didSet {
      onItemChanged.fire(item)
    }
  }

  public let onItemChanged: Observer<Item>

  init(item: Item) {
    self.item = item
    self.onItemChanged = .init()
  }

}
