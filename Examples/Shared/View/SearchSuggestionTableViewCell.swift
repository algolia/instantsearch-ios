//
//  SearchSuggestionTableViewCell.swift
//  Examples
//
//  Created by Vladislav Fitc on 04/11/2021.
//

import Foundation
import UIKit

class SearchSuggestionTableViewCell: UITableViewCell {

  var didTapTypeAheadButton: (() -> Void)?

  private func typeAheadButton() -> UIButton {
    let typeAheadButton = UIButton()
    typeAheadButton.setImage(UIImage(systemName: "arrow.up.left"), for: .normal)
    typeAheadButton.sizeToFit()
    typeAheadButton.addTarget(self, action: #selector(typeAheadButtonTap), for: .touchUpInside)
    return typeAheadButton
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    accessoryView = typeAheadButton()
    imageView?.image = UIImage(systemName: "magnifyingglass")
    tintColor = .lightGray
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func typeAheadButtonTap(_ sender: UIButton) {
    didTapTypeAheadButton?()
  }

}
