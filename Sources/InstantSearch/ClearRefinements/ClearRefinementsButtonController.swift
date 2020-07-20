//
//  ClearRefinementsButtonController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 24/05/2019.
//

#if !InstantSearchCocoaPods
@_exported import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

public class FilterClearButtonController: FilterClearController {

  public let button: UIButton

  public var onClick: (() -> Void)?

  public init(button: UIButton) {
    self.button = button
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }

  @objc private func didTapButton() {
    onClick?()
  }

}
#endif
