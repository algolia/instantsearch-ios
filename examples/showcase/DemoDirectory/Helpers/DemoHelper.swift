//
//  DemoHelper.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 06/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

extension SearchClient {
  static let demo = Self(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
  static let newDemo = Self(appID: "latency", apiKey: "927c3fe76d4b52c5a2912973f35a3077")
  static let recommend = Self(appID: "XX85YRZZMV", apiKey: "d17ff64e913b3293cfba3d3665480217")
}

extension Index {
  
  static func demo(withName demoIndexName: IndexName) -> Index {
    return SearchClient.demo.index(withName: demoIndexName)
  }
  
}

extension IndexName {
  static let recommend: IndexName = "test_FLAGSHIP_ECOM_recommend"
}

extension Index {
  
  struct Ecommerce {
    static let products: IndexName = "STAGING_native_ecom_demo_products"
    static let productsAsc: IndexName = "STAGING_native_ecom_demo_products_products_price_asc"
    static let productsDesc: IndexName = "STAGING_native_ecom_demo_products_products_price_desc"
    static let suggestions: IndexName = "STAGING_native_ecom_demo_products_query_suggestions"
  }
  
}

struct DemoHelper {
  public static let appID = "latency"
  public static let apiKey = "1f6fd3a6fb973cb08419fe7d288fa4db"
}

extension IndexPath {
  static let zero = IndexPath(row: 0, section: 0)
}
