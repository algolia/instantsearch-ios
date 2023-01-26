//
//  SuggestionCollectionViewCell.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 18/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell {
  let label: UILabel

  override init(frame: CGRect) {
    label = UILabel(frame: .zero)
    super.init(frame: frame)
    layout()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func layout() {
    contentView.backgroundColor = .systemBackground
    contentView.layer.cornerRadius = 12
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.numberOfLines = 0
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
                                    inverted: false,
                                    attributes: [.foregroundColor: UIColor.tintColor])
      }
  }
}
