//
//  SearchClient.swift
//  Guides
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import Foundation
import AlgoliaSearchClient

extension SearchClient {
  static let instantSearch = Self(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
  static let ecommerce = Self(appID: "latency", apiKey: "927c3fe76d4b52c5a2912973f35a3077")
  static let ecommerceRecommend = Self(appID: "XX85YRZZMV", apiKey: "d17ff64e913b3293cfba3d3665480217")
  static let tmdb = Self(appID: "latency", apiKey: "3832e8fcaf80b1c7085c59fa3e4d266d")
}

extension IndexName {
  static let ecommerceProducts: IndexName = "STAGING_native_ecom_demo_products"
  static let ecommerceProductsAsc: IndexName = "STAGING_native_ecom_demo_products_products_price_asc"
  static let ecommerceProductsDesc: IndexName = "STAGING_native_ecom_demo_products_products_price_desc"
  static let ecommerceSuggestions: IndexName = "STAGING_native_ecom_demo_products_query_suggestions"
  static let tmdbMovies: IndexName = "tmdb_movies_shows"
}


extension RecommendClient {
  static let ecommerceRecommend = Self(appID: "XX85YRZZMV", apiKey: "d17ff64e913b3293cfba3d3665480217")
}

extension IndexName {
  static let ecommerceRecommend: IndexName = "test_FLAGSHIP_ECOM_recommend"
}
