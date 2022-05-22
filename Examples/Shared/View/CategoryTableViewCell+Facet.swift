//
//  CategoryTableViewCell+Facet.swift
//  Examples
//
//  Created by Vladislav Fitc on 13/12/2021.
//

import Foundation
import UIKit
import AlgoliaSearchClient

extension CategoryTableViewCell {

  func setup(with facet: Facet) {
    guard let textLabel = textLabel else { return }
    if let rawHighlighted = facet.highlighted {
      let highlightedValue = HighlightedString(string: rawHighlighted)
      textLabel.attributedText = NSAttributedString(highlightedString: highlightedValue,
                                                    attributes: [
                                                      .font: UIFont.systemFont(ofSize: textLabel.font.pointSize, weight: .bold)
                                                    ])
    } else {
      textLabel.text = facet.value
    }
  }

}
