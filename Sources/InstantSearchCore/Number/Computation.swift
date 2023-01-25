//
//  Computation.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 04/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public class Computation<N: Numeric> {
  var numeric: N? {
    didSet {
      onNumericUpdate(numeric)
    }
  }

  var onNumericUpdate: (N?) -> Void

  public init(numeric: N?, onNumericUpdate: @escaping ((N?) -> Void)) {
    self.numeric = numeric
    self.onNumericUpdate = onNumericUpdate
  }

  public func increment(step: N = 1, default: N = 0) {
    numeric = (numeric != nil) ? numeric! + step : `default`
  }

  public func decrement(step: N = 1, default: N = 0) {
    numeric = (numeric != nil) ? numeric! - step : `default`
  }

  public func multiply(step: N = 1, default: N = 0) {
    numeric = (numeric != nil) ? numeric! * step : `default`
  }

  public func just(value: N?) {
    numeric = value
  }
}
