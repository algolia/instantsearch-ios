//
//  StoreItemCollection ViewCell.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/03/2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation
import UIKit


class StoreItemCollectionViewCell: UICollectionViewCell {
  
  let storeItemView: StoreItemView

  override init(frame: CGRect) {
    storeItemView = .init(frame: .zero)
    storeItemView.mainStackView.axis = .vertical
    super.init(frame: frame)
    storeItemView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(storeItemView)
    storeItemView.pin(to: contentView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

