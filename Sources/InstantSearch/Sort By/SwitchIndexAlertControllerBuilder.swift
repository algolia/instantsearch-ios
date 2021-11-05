//
//  SwitchIndexAlertControllerBuilder.swift
//  
//
//  Created by Vladislav Fitc on 15/09/2021.
//

import Foundation
#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

/// Constructs a UIAlertController instance with the indices names list and dispatches the selected index name
public class SwitchIndexAlertControllerBuilder: SelectableSegmentController {

  public typealias SegmentKey = Int

  /// List of the indices names
  public var indicesNames: [Int: String]

  /// Currently selected index name
  public var selectedIndex: Int?

  public var onClick: ((Int) -> Void)?

  public init() {
    self.indicesNames = [:]
    self.selectedIndex = .none
  }

  public func setSelected(_ selected: Int?) {
    selectedIndex = selected
  }

  public func setItems(items: [Int: String]) {
    indicesNames = items
  }

  /// - parameters:
  ///   - title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
  ///   - message: Descriptive text that provides additional details about the reason for the alert.
  ///   - cancelTitle: The title of the cancel action on the bottom of the alert. If not provided, the cancel action won't be added.
  ///   - preferredStyle: The style to use when presenting the alert controller. Use this parameter to configure the alert controller as an action sheet or as a modal alert.
  public func build(title: String? = nil,
                    message: String? = nil,
                    cancelTitle: String? = nil,
                    preferredStyle: UIAlertController.Style = .actionSheet) -> UIAlertController {
    let alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .actionSheet)
    indicesNames
      .sorted(by: \.key)
      .map { (index, indexName) in
        UIAlertAction(title: indexName, style: .default) { [weak self] _ in
          guard let controller = self else { return }
          if index != controller.selectedIndex {
            controller.onClick?(index)
          }
        }
      }
      .forEach(alertController.addAction)
    cancelTitle.flatMap {
      alertController.addAction(.init(title: $0, style: .cancel, handler: nil))
    }
    return alertController
  }

}
#endif
