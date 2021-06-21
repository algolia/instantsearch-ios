//
//  SelectableSegmentController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 13/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol SelectableSegmentController: AnyObject {

  associatedtype SegmentKey: Hashable

  var onClick: ((SegmentKey) -> Void)? { get set }

  func setSelected(_ selected: SegmentKey?)
  func setItems(items: [SegmentKey: String])

}
