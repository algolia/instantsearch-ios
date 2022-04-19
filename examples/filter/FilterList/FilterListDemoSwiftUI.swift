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

struct FilterListDemoSwiftUI: PreviewProvider {
  
  class Controller<F: FilterType & Hashable> {
    
    let title: String
    let observableController: FilterListObservableController<F>
    let demoController: FilterListDemoController<F>
    let filters: [F]
    let description: (F) -> String
    
    init(title: String,
         filters: [F],
         selectionMode: SelectionMode,
         description: @escaping (F) -> String) {
      self.title = title
      self.observableController = .init()
      self.demoController = .init(filters: filters, controller: observableController, selectionMode: selectionMode)
      self.filters = filters
      self.description = description
    }
    
  }
  
  struct ContentView<Filter: FilterType & Hashable>: View {
    
    let title: String
    let description: (Filter) -> String
    let controller: FilterListObservableController<Filter>
    let filterStateController: FilterStateObservableController
    
    init(filterStateController: FilterStateObservableController,
         controller: FilterListObservableController<Filter>,
         description: @escaping (Filter) -> String,
         title: String) {
      self.filterStateController = filterStateController
      self.controller = controller
      self.description = description
      self.title = title
    }
    
    public var body: some View {
      VStack {
        FilterStateDebugView(filterStateController)
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
  
  class ViewController<F: FilterType & Hashable>: UIHostingController<ContentView<F>> {
    
    let controller: Controller<F>
    let filterStateObservableController: FilterStateObservableController
    
    init(controller: Controller<F>) {
      self.controller = controller
      filterStateObservableController = .init(filterState: controller.demoController.filterState)
      let contentView = ContentView(filterStateController: filterStateObservableController,
                                    controller: controller.observableController,
                                    description: controller.description,
                                    title: controller.title)
      super.init(rootView: contentView)
      UIScrollView.appearance().keyboardDismissMode = .interactive
      
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
  
  static func facetViewController() -> ViewController<FacetFilter> {
    return ViewController(controller: facetController)
  }
  
  static func numericViewController() -> ViewController<NumericFilter> {
    return ViewController(controller: numericController)
  }
  
  static func tagViewController() -> ViewController<TagFilter> {
    return ViewController(controller: tagController)
  }
  
  static let facetController = Controller(title: "Color",
                                          filters: ["red",
                                                    "blue",
                                                    "green",
                                                    "yellow",
                                                    "black"].map {
    FacetFilter(attribute: "color", stringValue: $0)
  },
                                          selectionMode: .multiple,
                                          description: \.value.description)
  
  
  static let numericController = Controller(title: "Price", filters: [
    NumericFilter(attribute: "price", operator: .lessThan, value: 5),
    NumericFilter(attribute: "price", range: 5...10),
    NumericFilter(attribute: "price", range: 10...25),
    NumericFilter(attribute: "price", range: 25...100),
    NumericFilter(attribute: "price", operator: .greaterThan, value: 100)
  ], selectionMode: .single,
                                            description: \.value.description)
  
  
  static let tagController = Controller(title: "Promotion",
                                        filters: [Filter.Tag]([
                                          "coupon",
                                          "free shipping",
                                          "free return",
                                          "on sale",
                                          "no exchange"
                                        ]),
                                        selectionMode: .multiple,
                                        description: \.value.description)
  
  static var previews: some View {
    NavigationView {
      ContentView(filterStateController: FilterStateObservableController(filterState: facetController.demoController.filterState),
                  controller: facetController.observableController,
                  description: \.value.description,
                  title: facetController.title)
    }
    NavigationView {
      ContentView(filterStateController: FilterStateObservableController(filterState: numericController.demoController.filterState),
                  controller: numericController.observableController,
                  description: \.value.description,
                  title: numericController.title)
    }
    NavigationView {
      ContentView(filterStateController: FilterStateObservableController(filterState: tagController.demoController.filterState),
                  controller: tagController.observableController,
                  description: \.value.description,
                  title: tagController.title)
    }
  }
  
}
