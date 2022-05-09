//
//  ContentView.swift
//  MediaDemo
//
//  Created by Vladislav Fitc on 09/05/2022.
//

import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct ContentView: View {
  
  @ObservedObject var queryInputController: QueryInputObservableController
  @ObservedObject var hitsController: HitsObservableController<Hit<Movie>>
  
  var body: some View {
    HitsList(hitsController) { hit, _ in
      MovieRow(movieHit: hit!)
        .frame(height: 80)
        .padding(.vertical, 3)
      Divider()
    } noResults: {
      Text("No Results")
    }
    .searchable(text: $queryInputController.query)
    .navigationBarTitle("Movies")
  }
  
}

struct ContentView_Previews: PreviewProvider {
  
  static let controller = Controller()
  
  static var previews: some View {
    NavigationView {
      ContentView(queryInputController: controller.queryInputController,
                  hitsController: controller.hitsController)
    }
    .navigationBarTitle("Movies")
  }
  
}
