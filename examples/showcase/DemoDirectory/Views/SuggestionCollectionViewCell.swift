//
//  SuggestionCollectionViewCell.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 18/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

class SuggestionCollectionViewCell: UICollectionViewCell {
  
  let label: UILabel
  
  override init(frame: CGRect) {
    self.label = UILabel(frame: .zero)
    super.init(frame: frame)
    layout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layout() {
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.numberOfLines = 0
    contentView.backgroundColor = .white
    contentView.addSubview(label)
    label.pin(to: contentView.layoutMarginsGuide)
  }
  
}

extension SuggestionCollectionViewCell {
  
  func setup(with querySuggestion: QuerySuggestion) {
    label.attributedText = querySuggestion
      .highlighted
      .flatMap(HighlightedString.init)
      .flatMap { NSAttributedString(highlightedString: $0,
                                    inverted: true,
                                    attributes: [.font: UIFont.boldSystemFont(ofSize: label.font.pointSize)])
    }
  }
  
}
