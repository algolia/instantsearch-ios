//
//  ProductTableViewCell+StoreItem.swift
//  Examples
//
//  Created by Vladislav Fitc on 20/04/2022.
//

import Foundation
import UIKit
import AlgoliaSearchClient

extension ProductTableViewCell {

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
      priceLabel.text = "\(price) €"
    }

  }

}
