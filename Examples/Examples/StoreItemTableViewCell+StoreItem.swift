//
//  StoreItemTableViewCell+StoreItem.swift
//  Examples
//
//  Created by Vladislav Fitc on 13/12/2021.
//

import Foundation
import UIKit
import AlgoliaSearchClient
import InstantSearchCore

extension StoreItemView {

  func setup(with productHit: Hit<StoreItem>) {
    let product = productHit.object
    itemImageView.sd_setImage(with: product.images.first)

    if let highlightedName = productHit.hightlightedString(forKey: "name") {
      titleLabel.attributedText = NSAttributedString(highlightedString: highlightedName,
                                                     attributes: [
                                                      .foregroundColor: UIColor.tintColor])
    } else {
      titleLabel.text = product.name
    }

    if let highlightedDescription = productHit.hightlightedString(forKey: "brand") {
      subtitleLabel.attributedText = NSAttributedString(highlightedString: highlightedDescription,
                                                        attributes: [
                                                          .foregroundColor: UIColor.tintColor
                                                        ])
    } else {
      subtitleLabel.text = product.brand
    }

    if let price = product.price {
      priceLabel.text = "\(price.value) €"
    }

  }

}

extension StoreItemCollectionViewCell {

  func setup(with productHit: Hit<StoreItem>) {
    storeItemView.setup(with: productHit)
  }

}

extension StoreItemTableViewCell {

  func setup(with productHit: Hit<StoreItem>) {
    storeItemView.setup(with: productHit)
  }

}
