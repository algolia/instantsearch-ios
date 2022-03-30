//
//  CurrentFiltersDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct CurrentFiltersDemoSwiftUI: PreviewProvider {
  
  struct ContentView: View {
    
    @ObservedObject var currentFiltersController: CurrentFiltersObservableController
    
    var body: some View {
      NavigationView {
        VStack {
          let filtersPerGroup = Dictionary(grouping: currentFiltersController.filters) { $0.id }
            .mapValues { $0.map(\.filter) }
            .map { $0 }
          ForEach(filtersPerGroup, id: \.key) { (group, filters) in
            HStack {
              Text(group.description)
                .bold()
                .padding(.leading)
              Spacer()
            }
            .padding(.vertical, 5)
            .background(Color(.systemGray5))
            ForEach(filters, id: \.self) { filter in
              HStack {
                Text(filter.description)
                  .padding(.leading)
                Spacer()
              }
            }
          }
          Spacer()
        }.navigationBarTitle("Filters")
      }
    }
    
  }
  
  static var previews: some View {
    ContentView(currentFiltersController: .init(filters: [
      .init(filter: .facet(.init(attribute: "brand", stringValue: "sony")), id: .and(name: "groupA")),
      .init(filter: .numeric(.init(attribute: "price", range: 50...100)), id: .and(name: "groupA")),
      .init(filter: .tag("Free delivery"), id: .and(name: "groupA")),
      .init(filter: .numeric(.init(attribute: "salesRank", operator: .lessThan, value: 100)), id: .and(name: "groupB")),
      .init(filter: .tag("On Sale"), id: .and(name: "groupB"))
    ]))
  }
  
}
