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
  
  struct ContentView: View {
    
    @ObservedObject var colorController: FacetListObservableController
    @ObservedObject var promotionController: FacetListObservableController
    @ObservedObject var categoryController: FacetListObservableController
    
    var body: some View {
      NavigationView {
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
        .padding()
        .navigationBarTitle("Refinement List")
      }
    }
    
  }
    
  static let colorController = FacetListObservableController()
  static let promotionController = FacetListObservableController()
  static let categoryController = FacetListObservableController()
  
  static let demoController = RefinementListDemoController(colorController: colorController,
                                                           promotionController: promotionController,
                                                           categoryController: categoryController)
  
  static var previews: some View {
    ContentView(colorController: colorController,
                promotionController: promotionController,
                categoryController: categoryController)
      .onAppear {
        let _ = demoController
      }
  }
      
}
