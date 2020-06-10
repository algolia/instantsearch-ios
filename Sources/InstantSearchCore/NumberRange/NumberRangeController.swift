//
//  NumberRangeController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol NumberRangeController: ItemController where Item == ClosedRange<Number> {
  associatedtype Number: Comparable

  var onRangeChanged: ((ClosedRange<Number>) -> Void)? { get set }
  func setBounds(_ bounds: ClosedRange<Number>)
}
