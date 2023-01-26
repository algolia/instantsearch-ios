//
//  CategoryTableViewCell.swift
//  Examples
//
//  Created by Vladislav Fitc on 04/11/2021.
//

import Foundation
import InstantSearch
import UIKit

class CategoryTableViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    imageView?.image = UIImage(systemName: "square.grid.2x2")
    tintColor = .lightGray
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
