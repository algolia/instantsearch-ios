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

struct FilterListDemoView<Filter: FilterType & Hashable>: View {
  
  let title: String
  let description: (Filter) -> String
  let controller: FilterListObservableController<Filter>
  @ObservedObject var filterState: FilterStateObservable
  
  init(filterState: FilterStateObservable,
       controller: FilterListObservableController<Filter>,
       description: @escaping (Filter) -> String,
       title: String) {
    self.filterState = filterState
    self.controller = controller
    self.description = description
    self.title = title
  }
  
  public var body: some View {
    NavigationView {
      VStack {
        VStack(alignment: .leading, spacing: 0) {
          Text("Filters")
            .fontWeight(.heavy)
            .font(.title3)
            .padding()
          Text(filterState.filtersString)
            .padding()
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               alignment: .leading)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color.black, lineWidth: 1)
        )
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
  
  func selectableText(text: String, isSelected: Bool) -> some View {
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
  
}


struct FilterListDemoSwiftUI: PreviewProvider {
  
  static func facet() -> FilterListSwiftUIDemoViewController<Filter.Facet> {
    return FilterListSwiftUIDemoViewController(filters: FilterListDemoSwiftUI.facetFilters,
                                               title: "Color",
                                               description: \.value.description)
  }
  
  static func numeric() -> FilterListSwiftUIDemoViewController<Filter.Numeric> {
    return FilterListSwiftUIDemoViewController(filters: FilterListDemoSwiftUI.numericFilters,
                                               title: "Price",
                                               description: \.value.description)
  }
  
  
  static func tag() -> FilterListSwiftUIDemoViewController<Filter.Tag> {
    return FilterListSwiftUIDemoViewController(filters: FilterListDemoSwiftUI.tagFilters,
                                               title: "Promotion",
                                               description: \.value.description)
  }
  
  
  
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

  static var previews: some View {
    let _ = facetFiltersDemoController
    FilterListDemoView(filterState: FilterStateObservable(filterState: facetFiltersDemoController.filterState),
                       controller: facetFiltersObservableController,
                       description: \.value.description,
                       title: "Color")
    let _ = numericFiltersDemoController
    FilterListDemoView(filterState: FilterStateObservable(filterState: facetFiltersDemoController.filterState),
                       controller: numericFiltersObservableController,
                       description: \.value.description,
                       title: "Price")
    let _ = tagFiltersDemoController
    FilterListDemoView(filterState: FilterStateObservable(filterState: facetFiltersDemoController.filterState),
                       controller: tagFiltersObservableController,
                       description: \.value.description,
                       title: "Promotion")
  }
  
}
