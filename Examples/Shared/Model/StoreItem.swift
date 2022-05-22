//
//  StoreItem.swift
//  QuerySuggestionsGuide
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import Foundation

struct StoreItem: Codable {

  let name: String
  let brand: String?
  let description: String?
  let images: [URL]
  let price: Double?

  enum CodingKeys: String, CodingKey {
    case name
    case brand
    case description
    case images = "image_urls"
    case price
  }

  enum PriceCodingKeys: String, CodingKey {
    case value
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.brand = try? container.decode(String.self, forKey: .brand)
    self.description = try? container.decode(String.self, forKey: .description)
    if let rawImages = try? container.decode([String].self, forKey: .images) {
      self.images = rawImages.compactMap(URL.init)
    } else {
      self.images = []
    }
    if
      let priceContainer = try? container.nestedContainer(keyedBy: PriceCodingKeys.self, forKey: .price),
      let price = try? priceContainer.decode(Double.self, forKey: .value) {
        self.price = price
    } else {
      self.price = .none
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(brand, forKey: .brand)
    try container.encode(description, forKey: .description)
    try container.encode(images, forKey: .images)
    try container.encode(price, forKey: .price)
  }

}
