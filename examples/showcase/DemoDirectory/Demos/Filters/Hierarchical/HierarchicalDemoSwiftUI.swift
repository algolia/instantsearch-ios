//
//  HierarchicalDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

class HierarchicalDemoSwiftUI: PreviewProvider {
    
  struct ContentView: View {
    
    let controller: HierarchicalObservableController
    
    var body: some View {
      NavigationView {
        VStack {
          HierarchicalList(controller) { facet, nestingLevel, isSelected in
              HierarchicalFacetRow(facet: facet,
                                   nestingLevel: nestingLevel,
                                   isSelected: isSelected)
                .frame(height: 30)
              Divider()
          }
          Spacer()
        }
        .padding()
        .navigationBarTitle("Hierarchical Filters")
      }
    }
    
  }
  
  static let controller: HierarchicalObservableController = .init()
  static let demoController = HierarchicalDemoController(controller: controller)
  
  static var previews: some View {
    ContentView(controller: controller)
      .onAppear {
        _ = demoController
      }
  }
  
}

