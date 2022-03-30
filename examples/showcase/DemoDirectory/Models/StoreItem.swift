//
//  StoreItem.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 21/03/2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation

struct StoreItem: Codable {
  
  let name: String
  let brand: String?
  let productType: String?
  let images: [URL]
  let price: Price?
  
  enum CodingKeys: String, CodingKey {
    case name
    case brand
    case productType = "product_type"
    case images = "image_urls"
    case image
    case price
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.brand = try? container.decode(String.self, forKey: .brand)
    self.productType = try? container.decode(String.self, forKey: .productType)
    if let rawImages = try? container.decode([String].self, forKey: .images) {
      self.images = rawImages.compactMap(URL.init)
    } else {
      self.images = (try? container.decode(URL.self, forKey: .image)).flatMap({ [$0] }) ?? []
    }
    if let price = try? container.decode(Price.self, forKey: .price) {
      self.price = price
    } else {
      self.price = nil
    }
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(brand, forKey: .brand)
    try container.encode(productType, forKey: .productType)
    try container.encode(images, forKey: .images)
    try container.encode(price, forKey: .price)
  }
  
}

struct Price: Codable {
  
  let currency: String
  let value: Double
  let discountedValue: Double?
  let discountLevel: Double?
  let onSales: Bool?
  
  var isDiscounted: Bool {
    discountedValue.flatMap { $0 > 0 } ?? false
  }
  
  enum CodingKeys: String, CodingKey {
    case currency
    case value
    case discountedValue = "discounted_value"
    case discountLevel = "discount_level"
    case onSales = "on_sales"
  }

}
