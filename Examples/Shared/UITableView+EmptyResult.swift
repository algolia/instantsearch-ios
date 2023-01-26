//
//  UITableView+EmptyResult.swift
//  Guides
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import Foundation
import UIKit

extension UITableView {
  func setEmptyMessage(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = .black
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.sizeToFit()

    backgroundView = messageLabel
    separatorStyle = .none
  }

  func restore() {
    backgroundView = nil
    separatorStyle = .singleLine
  }
}
