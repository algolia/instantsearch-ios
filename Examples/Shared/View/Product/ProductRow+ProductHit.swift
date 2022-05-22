//
//  ProductRow+ProductHit.swift
//  Examples
//
//  Created by Vladislav Fitc on 20/04/2022.
//

import Foundation
import InstantSearchCore

extension ProductRow {

  init(productHit: Hit<Product>, configuration: Configuration = .phone) {
    let product = productHit.object
    self.title = productHit.hightlightedString(forKey: "name") ?? HighlightedString(string: product.name)
    self.subtitle = productHit.hightlightedString(forKey: "brand") ?? HighlightedString(string: product.brand ?? "")
    self.details = productHit.hightlightedString(forKey: "description") ?? HighlightedString(string: product.description)
    self.imageURL = product.image
    self.price = product.price
    self.configuration = configuration
  }

}
