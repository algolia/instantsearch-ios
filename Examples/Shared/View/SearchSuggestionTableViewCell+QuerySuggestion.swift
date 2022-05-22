//
//  SearchSuggestionTableViewCell+QuerySuggestion.swift
//  Examples
//
//  Created by Vladislav Fitc on 13/12/2021.
//

import Foundation
import UIKit
import InstantSearchCore

extension SearchSuggestionTableViewCell {

  func setup(with querySuggestion: QuerySuggestion) {
    guard let textLabel = textLabel else { return }
    textLabel.attributedText = querySuggestion
      .highlighted
      .flatMap(HighlightedString.init)
      .flatMap { NSAttributedString(highlightedString: $0,
                                    inverted: true,
                                    attributes: [.font: UIFont.boldSystemFont(ofSize: textLabel.font.pointSize)])
    }
  }

}
