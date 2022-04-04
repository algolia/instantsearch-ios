//
//  SearchClient.swift
//  Guides
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import Foundation
import AlgoliaSearchClient

extension SearchClient {
  static let demo = Self(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
  static let newDemo = Self(appID: "latency", apiKey: "927c3fe76d4b52c5a2912973f35a3077")
  static let recommend = Self(appID: "XX85YRZZMV", apiKey: "d17ff64e913b3293cfba3d3665480217")
}


extension Index {
  
  struct Ecommerce {
    static let products: IndexName = "STAGING_native_ecom_demo_products"
    static let productsAsc: IndexName = "STAGING_native_ecom_demo_products_products_price_asc"
    static let productsDesc: IndexName = "STAGING_native_ecom_demo_products_products_price_desc"
    static let suggestions: IndexName = "STAGING_native_ecom_demo_products_query_suggestions"
  }
  
  
}
