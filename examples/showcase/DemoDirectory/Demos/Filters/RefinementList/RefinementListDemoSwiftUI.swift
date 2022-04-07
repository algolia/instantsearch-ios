//
//  RefinementListDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 18/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

class RefinementListDemoSwiftUI: PreviewProvider {
  
  class Controller {
    
    let filterStateController: FilterStateObservableController
    let colorController: FacetListObservableController
    let promotionController: FacetListObservableController
    let categoryController: FacetListObservableController
    let demoController: RefinementListDemoController
    
    init() {
      colorController = FacetListObservableController()
      promotionController = FacetListObservableController()
      categoryController = FacetListObservableController()
      demoController = RefinementListDemoController(colorController: colorController,
                                                    promotionController: promotionController,
                                                    categoryController: categoryController)
      filterStateController = FilterStateObservableController(filterState: demoController.filterState)
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var colorController: FacetListObservableController
    @ObservedObject var promotionController: FacetListObservableController
    @ObservedObject var categoryController: FacetListObservableController
    
    var body: some View {
      NavigationView {
        VStack {
          FilterStateDebugView(filterStateController)
            .padding()
          ScrollView {
            VStack {
              ForEach([
                (title: "Color", controller: colorController),
                (title: "Promotion", controller: promotionController),
                (title: "Category", controller: categoryController),
              ], id: \.title) { facetElement in
                VStack {
                  HStack {
                    Text(facetElement.title)
                      .font(.headline)
                    Spacer()
                  }
                  .padding(.bottom, 5)
                  FacetList(facetElement.controller) { facet, isSelected in
                    FacetRow(facet: facet, isSelected: isSelected)
                      .frame(height: 40)
                    Divider()
                  }
                }
                .padding(.bottom, 15)
              }
              Spacer()
            }
          }
          .padding()
          .navigationBarTitle("Refinement List")
        }
      }
    }
    
  }
  
  class ViewController: UIHostingController<ContentView> {
    
    let controller: Controller
    
    init() {
      controller = Controller()
      let rootView = RefinementListDemoSwiftUI.ContentView(filterStateController: controller.filterStateController,
                                                           colorController: controller.colorController,
                                                           promotionController: controller.promotionController,
                                                           categoryController: controller.categoryController)
      super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
    
  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return ContentView(filterStateController: controller.filterStateController,
                       colorController: controller.colorController,
                       promotionController: controller.promotionController,
                       categoryController: controller.categoryController)
  }
  
}
