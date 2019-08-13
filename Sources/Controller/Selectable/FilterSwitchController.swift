//
//  UISwitch+SelectableViewController.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 03/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public class FilterSwitchController<F: FilterType>: SelectableController {
  
  public typealias Item = F
  
  public let `switch`: UISwitch
  
  public var onClick: ((Bool) -> Void)?
  
  public init(`switch`: UISwitch) {
    self.switch = `switch`
    `switch`.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
  }
  
  @objc func didToggleSwitch(_ switch: UISwitch) {
    onClick?(`switch`.isOn)
  }
  
  public func setSelected(_ isSelected: Bool) {
    self.switch.isOn = isSelected
  }
  
  public func setItem(_ item: F) {
    
  }
  
}
