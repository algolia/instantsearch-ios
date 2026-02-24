//
//  CategoryTableViewCell+Facet.swift
//  Examples
//
//  Created by Vladislav Fitc on 13/12/2021.
//

import Foundation
import InstantSearchCore
import UIKit

extension CategoryTableViewCell {
  func setup(with facet: FacetHits) {
    guard let textLabel = textLabel else { return }
    if !facet.highlighted.isEmpty {
      let highlightedValue = HighlightedString(string: facet.highlighted)
      textLabel.attributedText = NSAttributedString(highlightedString: highlightedValue,
                                                    attributes: [
                                                      .font: UIFont.systemFont(ofSize: textLabel.font.pointSize, weight: .bold)
                                                    ])
    } else {
      textLabel.text = facet.value
    }
  }
}
