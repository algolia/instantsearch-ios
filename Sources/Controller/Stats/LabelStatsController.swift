//
//  LabelStatsController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 23/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

extension Optional where Wrapped == Bool {

  var falseOrNil: Bool {
    switch self {
    case .some(true):
      return false
    default:
      return true
    }
  }

}

public class LabelStatsController: StatsTextController {

  public let label: UILabel

  public init (label: UILabel) {
    self.label = label
  }
  
  public func setItem(_ item: String?) {
    label.text = item
  }

}

public class AttributedLabelStatsController: ItemAttributedTextController {
  
  public let label: UILabel
  
  public init (label: UILabel) {
    self.label = label
  }
  
  public func setItem(_ item: NSAttributedString?) {
    label.attributedText = item
  }

}
