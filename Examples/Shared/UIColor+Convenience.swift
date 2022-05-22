//
//  UIColor+Convenience.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 08/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

  // swiftlint:disable identifier_name
  convenience init(hexString: String) {
    var hexFormatted = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    if hexFormatted.hasPrefix("#") {
      hexFormatted = String(hexFormatted.dropFirst())
    }
    var rgbValue = UInt64()
    Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
    let a, r, g, b: UInt64
    switch hexFormatted.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (rgbValue >> 8) * 17, (rgbValue >> 4 & 0xF) * 17, (rgbValue & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, rgbValue >> 16, rgbValue >> 8 & 0xFF, rgbValue & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (rgbValue >> 24, rgbValue >> 16 & 0xFF, rgbValue >> 8 & 0xFF, rgbValue & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(red: CGFloat(r) / 255,
              green: CGFloat(g) / 255,
              blue: CGFloat(b) / 255,
              alpha: CGFloat(a) / 255)
  }

  static let algoliaCyan = UIColor(hexString: "5468FF")

}

extension CGColor {

  static let algoliaCyan = CGColor(red: 84/255, green: 104/255, blue: 255/255, alpha: 1)

}
