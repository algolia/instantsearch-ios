//
//  FilterDebugController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 23/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

class FilterDebugController {

  let stateLabel: UILabel
  let emptyMessage = NSAttributedString(string: "No filters applied")
  var colorMap: [String: UIColor]

  init() {
    stateLabel = UILabel(frame: .zero)
    colorMap = [:]
    stateLabel.attributedText = emptyMessage
    stateLabel.font = .systemFont(ofSize: 16)
    stateLabel.numberOfLines = 0
  }

  func connectTo(_ filterState: FilterState) {
    filterState.onChange.subscribePast(with: self) { viewController, filterState in
      let filtersText = filterState.toFilterGroups().sqlFormWithSyntaxHighlighting(colorMap: viewController.colorMap)
      viewController.stateLabel.attributedText = filtersText.string.isEmpty ?  viewController.emptyMessage : filtersText
    }.onQueue(.main)
  }

}

extension Collection where Element == FilterGroupType {

  public func sqlFormWithSyntaxHighlighting(colorMap: [String: UIColor]) -> NSAttributedString {
    let converter = FilterGroupConverter()
    let groupsSeparator = " AND "
    return compactMap { element -> NSAttributedString? in

      let color: UIColor

      if let groupName = element.name, let specifiedColor = colorMap[groupName] {
        color = specifiedColor
      } else {
        color = .darkText
      }

      return converter.sql(element)
        .flatMap { $0.replacingOccurrences(of: "\"", with: "") }
        .flatMap { sqlString in
          return NSMutableAttributedString()
            .appendWith(color: color, weight: .regular, ofSize: 18.0, sqlString)
      }

      }
      .joined(separator: NSMutableAttributedString()
        .appendWith(weight: .semibold, ofSize: 18.0, groupsSeparator))
  }

}

extension NSMutableAttributedString {

  @discardableResult func appendWith(color: UIColor = UIColor.darkText, weight: UIFont.Weight = .regular, ofSize: CGFloat = 12.0, _ text: String) -> NSMutableAttributedString {
    let attrText = NSAttributedString.makeWith(color: color, weight: weight, ofSize: ofSize, text)
    self.append(attrText)
    return self
  }

}
extension NSAttributedString {

  public static func makeWith(color: UIColor = UIColor.darkText, weight: UIFont.Weight = .regular, ofSize: CGFloat = 12.0, _ text: String) -> NSMutableAttributedString {
    let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ofSize, weight: weight), NSAttributedString.Key.foregroundColor: color]
    return NSMutableAttributedString(string: text, attributes: attrs)
  }
}

extension Sequence where Iterator.Element: NSAttributedString {
  /// Returns a new attributed string by concatenating the elements of the sequence, adding the given separator between each element.
  /// - parameters:
  ///     - separator: A string to insert between each of the elements in this sequence. The default separator is an empty string.
  func joined(separator: NSAttributedString = NSAttributedString(string: "")) -> NSAttributedString {
    var isFirst = true
    return self.reduce(NSMutableAttributedString()) { (source, string) in
      if isFirst {
        isFirst = false
      } else {
        source.append(separator)
      }
      source.append(string)
      return source
    }
  }

  /// Returns a new attributed string by concatenating the elements of the sequence, adding the given separator between each element.
  /// - parameters:
  ///     - separator: A string to insert between each of the elements in this sequence. The default separator is an empty string.
  func joined(separator: String = "") -> NSAttributedString {
    return joined(separator: NSAttributedString(string: separator))
  }

}
