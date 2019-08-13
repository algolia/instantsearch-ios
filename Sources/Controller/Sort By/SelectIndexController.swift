//
//  SelectIndexController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 06/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public class SelectIndexController: NSObject, SelectableSegmentController {

  typealias Key = Int

  public let alertController: UIAlertController

  public var onClick: ((Int) -> Void)?

  public init(alertController: UIAlertController) {
    self.alertController = alertController
    super.init()
  }

  public func setSelected(_ selected: Int?) {

  }

  public func setItems(items: [Int: String]) {
    guard alertController.actions.isEmpty else { return }
    for item in items {
      alertController.addAction(UIAlertAction(title: item.value, style: .default, handler: { [weak self] _ in
        self?.onClick?(item.key)
      }))
    }
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
  }

}
