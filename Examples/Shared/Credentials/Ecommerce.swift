//
//  Ecommerce.swift
//  TVSearch
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import AlgoliaSearchClient
import Foundation

extension SearchClient {
  static let ecommerce = Self(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
  static let ecommerceRecommend = Self(appID: "XX85YRZZMV", apiKey: "d17ff64e913b3293cfba3d3665480217")
}

extension IndexName {
  static let ecommerceProducts: IndexName = "STAGING_native_ecom_demo_products"
  static let ecommerceProductsAsc: IndexName = "STAGING_native_ecom_demo_products_products_price_asc"
  static let ecommerceProductsDesc: IndexName = "STAGING_native_ecom_demo_products_products_price_desc"
  static let ecommerceSuggestions: IndexName = "STAGING_native_ecom_demo_products_query_suggestions"
  
  static let instantSearch: IndexName = "instant_search"
}

extension RecommendClient {
  static let ecommerceRecommend = Self(appID: "XX85YRZZMV", apiKey: "d17ff64e913b3293cfba3d3665480217")
}

extension IndexName {
  static let ecommerceRecommend: IndexName = "test_FLAGSHIP_ECOM_recommend"
}
