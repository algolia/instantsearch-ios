//
//  Product.swift
//  Examples
//
//  Created by Vladislav Fitc on 04/11/2021.
//

import Foundation

struct Product: Codable {

  let name: String
  let description: String
  let brand: String?
  let image: URL
  let price: Double?

}
