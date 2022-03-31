//
//  StoreItemTableViewCell.swift
//  Guides
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import Foundation
import AlgoliaSearchClient
import UIKit

class StoreItemTableViewCell: UITableViewCell {
  
  let storeItemView: StoreItemView

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    storeItemView = .init(frame: .zero)
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    storeItemView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(storeItemView)
    NSLayoutConstraint.activate([
      storeItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
      storeItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      storeItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      storeItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
