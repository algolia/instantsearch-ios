//
//  Ecommerce.swift
//  TVSearch
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import Foundation
import AlgoliaSearch

#if canImport(Recommend)
import Recommend
#endif

extension SearchClient {
  static let ecommerce = try! SearchClient(appID: "latency", apiKey: "927c3fe76d4b52c5a2912973f35a3077")
  static let ecommerceRecommend = try! SearchClient(appID: "XX85YRZZMV", apiKey: "d17ff64e913b3293cfba3d3665480217")
}

extension String {
  static let ecommerceProducts = "STAGING_native_ecom_demo_products"
  static let ecommerceProductsAsc = "STAGING_native_ecom_demo_products_products_price_asc"
  static let ecommerceProductsDesc = "STAGING_native_ecom_demo_products_products_price_desc"
  static let ecommerceSuggestions = "STAGING_native_ecom_demo_products_query_suggestions"
}

#if canImport(Recommend)
extension RecommendClient {
  static let ecommerceRecommend = try! RecommendClient(appID: "XX85YRZZMV", apiKey: "d17ff64e913b3293cfba3d3665480217")
}
#endif

extension String {
  static let ecommerceRecommend = "test_FLAGSHIP_ECOM_recommend"
}
