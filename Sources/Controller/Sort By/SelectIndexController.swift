//
//  SelectIndexController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 06/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore

public class SelectIndexController: NSObject, SelectableSegmentController {

  typealias Key = Int

  let alertController: UIAlertController

  public var onClick: ((Int) -> Void)?

  public init(alertController: UIAlertController) {
    self.alertController = alertController
    super.init()
  }

  public func setSelected(_ selected: Int?) {

  }

  public func setItems(items: [Int : String]) {
    if alertController.actions.isEmpty {
      for item in items {
        alertController.addAction(UIAlertAction(title: item.value, style: .default , handler:{ [weak self] (UIAlertAction) in
          self?.onClick?(item.key)
        }))
      }
    }
  }

}
