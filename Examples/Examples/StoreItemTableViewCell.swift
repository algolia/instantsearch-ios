//
//  StoreItemTableViewCell.swift
//  Examples
//
//  Created by Vladislav Fitc on 04/11/2021.
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
    storeItemView.pin(to: contentView)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
