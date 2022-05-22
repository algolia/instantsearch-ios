//
//  FilterListDemo.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

struct FilterListDemo {

  static func facet() -> FilterListDemoViewController<Filter.Facet> {

    let facetFilters: [Filter.Facet] = ["red", "blue", "green", "yellow", "black"].map {
      .init(attribute: "color", stringValue: $0)
    }

    return FilterListDemoViewController(items: facetFilters, selectionMode: .multiple)

  }

  static func numeric() -> FilterListDemoViewController<Filter.Numeric> {

    let numericFilters: [Filter.Numeric] = [
      .init(attribute: "price", operator: .lessThan, value: 5),
      .init(attribute: "price", range: 5...10),
      .init(attribute: "price", range: 10...25),
      .init(attribute: "price", range: 25...100),
      .init(attribute: "price", operator: .greaterThan, value: 100)
    ]

    return FilterListDemoViewController(items: numericFilters, selectionMode: .single)

  }

  static func tag() -> FilterListDemoViewController<Filter.Tag> {

    let tagFilters: [Filter.Tag] = [
      "coupon", "free shipping", "free return", "on sale", "no exchange"]

    return FilterListDemoViewController(items: tagFilters, selectionMode: .multiple)

  }

}
