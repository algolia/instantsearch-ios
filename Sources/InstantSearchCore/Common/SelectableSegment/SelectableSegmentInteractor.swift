//
//  SelectableSegmentInteractor.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 10/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class SelectableSegmentInteractor<SegmentKey: Hashable, Segment> {

  public var items: [SegmentKey: Segment] {
    didSet {
      onItemsChanged.fire(items)
    }
  }

  public var selected: SegmentKey? {
    didSet {
      onSelectedChanged.fire(selected)
    }
  }

  public let onItemsChanged: Observer<[SegmentKey: Segment]>
  public let onSelectedChanged: Observer<SegmentKey?>
  public let onSelectedComputed: Observer<SegmentKey?>

  public init(items: [SegmentKey: Segment], selected: SegmentKey? = .none) {
    self.items = items
    self.selected = selected
    self.onItemsChanged = .init()
    self.onSelectedChanged = .init()
    self.onSelectedComputed = .init()
    onItemsChanged.fire(items)
  }

  public func computeSelected(selecting keyToSelect: SegmentKey?) {
    onSelectedComputed.fire(keyToSelect)
  }

}
