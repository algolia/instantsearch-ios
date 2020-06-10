//
//  SelectableInteractor.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 03/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class SelectableInteractor<Item>: ItemInteractor<Item> {

  public var isSelected: Bool {
    didSet {
      onSelectedChanged.fire(isSelected)
    }
  }

  public let onSelectedChanged: Observer<Bool>
  public let onSelectedComputed: Observer<Bool>

  public override init(item: Item) {
    self.isSelected = false
    self.onSelectedChanged = .init()
    self.onSelectedComputed = .init()
    super.init(item: item)
  }

  public func computeIsSelected(selecting: Bool) {
    onSelectedComputed.fire(selecting)
  }

}
