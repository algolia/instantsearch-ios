//
//  Helpers.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 08/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }

  static let algoliaCyan = UIColor(hexString: "5468FF")

}

extension UIStackView {

  func addBackground(color: UIColor) {
    let subview = UIView(frame: bounds)
    subview.backgroundColor = color
    subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    insertSubview(subview, at: 0)
  }

}
