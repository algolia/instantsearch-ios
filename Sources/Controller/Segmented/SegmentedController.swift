//
//  SegmentedController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 08/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public class SegmentedController<Value: FilterType>: NSObject, SelectableSegmentController {
  
  public typealias Key = Int
  
  public let segmentedControl: UISegmentedControl
  
  public var onClick: ((Int) -> Void)?
  
  public init(segmentedControl: UISegmentedControl) {
    self.segmentedControl = segmentedControl
    super.init()
    segmentedControl.addTarget(self, action: #selector(didSelectSegment(_:)), for: .valueChanged)
  }

  public func setSelected(_ selected: Int?) {
    segmentedControl.selectedSegmentIndex = selected ?? UISegmentedControl.noSegment
  }
  
  public func setItems(items: [Int: String]) {
    segmentedControl.removeAllSegments()
    
    for item in items {
      segmentedControl.insertSegment(withTitle: item.value, at: item.key, animated: false)
    }
  }
  
  @objc private func didSelectSegment(_ segmentedControl: UISegmentedControl) {
    if segmentedControl.selectedSegmentIndex != UISegmentedControl.noSegment {
      onClick?(segmentedControl.selectedSegmentIndex)
    }
  }
  
}
