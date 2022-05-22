//
//  ProductCollectionViewCell.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/03/2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ProductCollectionViewCell: UICollectionViewCell {

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
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func layout() {
    contentView.backgroundColor = .systemBackground
    contentView.layer.cornerRadius = 12

    itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    itemImageView.translatesAutoresizingMaskIntoConstraints = false
    itemImageView.clipsToBounds = true
    itemImageView.contentMode = .scaleAspectFit
    itemImageView.layer.masksToBounds = true

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
    titleLabel.numberOfLines = 1

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

    mainStackView.axis = .vertical
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.spacing = 20
    mainStackView.addArrangedSubview(itemImageView)
    mainStackView.addArrangedSubview(labelsStackView)

    contentView.addSubview(mainStackView)
    layoutMargins = .init(top: 5, left: 3, bottom: 5, right: 3)

    itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor).isActive = true
    mainStackView.pin(to: layoutMarginsGuide)
  }

}
