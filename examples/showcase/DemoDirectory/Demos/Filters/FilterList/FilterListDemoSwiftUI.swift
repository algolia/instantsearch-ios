//
//  FilterListDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct FilterListDemoSwiftUI : PreviewProvider {
  
  static let facetFiltersObservableController = FilterListObservableController<Filter.Facet>()
  static let facetFilters = ["red", "blue", "green", "yellow", "black"].map {
    Filter.Facet(attribute: "color", stringValue: $0)
  }
  static let facetFiltersDemoController = FilterListDemoController(filters: facetFilters,
                                                                   controller: facetFiltersObservableController,
                                                                   selectionMode: .multiple)
  
  
  
  static let numericFiltersObservableController = FilterListObservableController<Filter.Numeric>()
  static let numericFilters: [Filter.Numeric] = [
    .init(attribute: "price", operator: .lessThan, value: 5),
    .init(attribute: "price", range: 5...10),
    .init(attribute: "price", range: 10...25),
    .init(attribute: "price", range: 25...100),
    .init(attribute: "price", operator: .greaterThan, value: 100)
  ]
  static let numericFiltersDemoController = FilterListDemoController(filters: numericFilters,
                                                                     controller: numericFiltersObservableController,
                                                                     selectionMode: .single)
  
  
  
  static let tagFiltersObservableController = FilterListObservableController<Filter.Tag>()
  static let tagFilters: [Filter.Tag] = [
    "coupon", "free shipping", "free return", "on sale", "no exchange"
  ]
  static let tagFiltersDemoController = FilterListDemoController(filters: tagFilters,
                                                                 controller: tagFiltersObservableController,
                                                                 selectionMode: .multiple)
    
  static func selectableText(text: String, isSelected: Bool) -> some View {
    HStack {
      Text(text)
      Spacer()
      if isSelected {
        Image(systemName: "checkmark")
          .foregroundColor(.accentColor)
      }
    }
    .contentShape(Rectangle())
  }
  
  static func filterList<Filter: FilterType>(with controller: FilterListObservableController<Filter>,
                                             title: String,
                                             description: @escaping (Filter) -> String) -> some View {
    NavigationView {
      VStack {
        FilterList(controller) { filter, isSelected in
          selectableText(text: description(filter), isSelected: isSelected)
            .frame(height: 44)
          Divider()
        }
        Spacer()
      }
      .navigationBarTitle(title)
      .padding()
    }
  }
  
  static var previews: some View {
    let _ = facetFiltersDemoController
    filterList(with: facetFiltersObservableController,
               title: "Color",
               description: \.value.description)
    let _ = numericFiltersDemoController
    filterList(with: numericFiltersObservableController,
               title: "Price",
               description: \.value.description)
    let _ = tagFiltersDemoController
    filterList(with: tagFiltersObservableController,
               title: "Promotion",
               description: \.value.description)
  }
  
}
