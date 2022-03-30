//
//  StoreItemView.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/03/2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class StoreItemView: UIView {
  
  let itemImageView: UIImageView
  let titleLabel: UILabel
  let subtitleLabel: UILabel
  let priceLabel: UILabel
  
  let mainStackView: UIStackView
  let labelsStackView: UIStackView
    
  override init(frame: CGRect) {
    itemImageView = .init(frame: .zero)
    titleLabel = .init(frame: .zero)
    subtitleLabel = .init(frame: .zero)
    mainStackView = .init(frame: .zero)
    labelsStackView = .init(frame: .zero)
    priceLabel = .init(frame: .zero)
    super.init(frame: frame)
    layout()
    backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layout() {
    itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    itemImageView.translatesAutoresizingMaskIntoConstraints = false
    itemImageView.clipsToBounds = true
    itemImageView.contentMode = .scaleAspectFit
    itemImageView.layer.masksToBounds = true

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
    titleLabel.numberOfLines = 2
    
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
    subtitleLabel.textColor = .gray
    subtitleLabel.numberOfLines = 0
    
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    priceLabel.font = .systemFont(ofSize: 14)
    
    labelsStackView.axis = .vertical
    labelsStackView.translatesAutoresizingMaskIntoConstraints = false
    labelsStackView.spacing = 3
    labelsStackView.addArrangedSubview(titleLabel)
    labelsStackView.addArrangedSubview(subtitleLabel)
    labelsStackView.addArrangedSubview(priceLabel)
    labelsStackView.addArrangedSubview(UIView())
    
    mainStackView.axis = .horizontal
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.spacing = 20
    mainStackView.addArrangedSubview(itemImageView)
    mainStackView.addArrangedSubview(labelsStackView)
    
    addSubview(mainStackView)
    layoutMargins = .init(top: 5, left: 3, bottom: 5, right: 3)
    
    NSLayoutConstraint.activate([
      itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor),
      mainStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
    ])
  }
  
}
