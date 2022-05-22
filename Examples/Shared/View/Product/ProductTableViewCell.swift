//
//  ProductTableViewCell.swift
//  Examples
//
//  Created by Vladislav Fitc on 30.03.2022.
//

import Foundation
import UIKit
import SDWebImage

class ProductTableViewCell: UITableViewCell {

  let itemImageView: UIImageView
  let titleLabel: UILabel
  let subtitleLabel: UILabel
  let priceLabel: UILabel

  let mainStackView: UIStackView
  let labelsStackView: UIStackView

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    itemImageView = .init()
    titleLabel = .init()
    subtitleLabel = .init()
    mainStackView = .init()
    labelsStackView = .init()
    priceLabel = .init()
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layout()
    backgroundColor = .systemBackground
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
    titleLabel.numberOfLines = 1

    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
    subtitleLabel.textColor = .systemGray
    subtitleLabel.numberOfLines = 1

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

    contentView.addSubview(mainStackView)
    contentView.layoutMargins = .init(top: 5, left: 3, bottom: 5, right: 3)

    mainStackView.pin(to: contentView.layoutMarginsGuide)
    itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor).isActive = true
  }

}
