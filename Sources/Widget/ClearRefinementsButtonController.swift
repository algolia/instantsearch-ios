//
//  ClearRefinementsButtonController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 24/05/2019.
//

import Foundation
import UIKit

public class ClearRefinementsButtonController: ClearRefinementsController {
  
  public let button: UIButton
  
  public var clearRefinements: (() -> Void)?
  
  public init(button: UIButton) {
    self.button = button
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }
  
  @objc private func didTapButton() {
    clearRefinements?()
  }
  
}
