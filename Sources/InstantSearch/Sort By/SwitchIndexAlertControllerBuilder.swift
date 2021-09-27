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
public class SwitchIndexAlertControllerBuilder: SwitchIndexController {

  /// List of the indices names
  public var indicesNames: [IndexName]

  /// Currently selected index name
  public var selectedIndexName: IndexName

  public var selectIndexWithName: (IndexName) -> Void = { _ in }

  /// Closure that provides a title for an index name
  public var getTitle: (IndexName) -> String

  /// - parameter getTitle: Closure that provides a title for an index name
  public init(getTitle: @escaping (IndexName) -> String) {
    self.indicesNames = []
    self.selectedIndexName = ""
    self.getTitle = getTitle
  }

  public func set(indicesNames: [IndexName], selected: IndexName) {
    self.indicesNames = indicesNames
    self.selectedIndexName = selected
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
      .map { indexName in
        UIAlertAction(title: getTitle(indexName), style: .default) { [weak self] _ in
          guard let controller = self else { return }
          if indexName != controller.selectedIndexName {
            controller.selectIndexWithName(indexName)
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
