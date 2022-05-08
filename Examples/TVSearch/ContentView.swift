//
//  ContentView.swift
//  TVSearch
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct ContentView: View {
  
  @ObservedObject var queryInputController: QueryInputObservableController
  @ObservedObject var hitsController: HitsObservableController<Hit<Movie>>
  
  var body: some View {
    NavigationView {
      HitsList(hitsController) { hit, _ in
        MovieRow(movieHit: hit!)
          .padding(.bottom, 10)
          .focusable(true)
        Divider()
      } noResults: {
        Text("No Results")
      }
    }
    .searchable(text: $queryInputController.query)
  }
  
}


struct ContentView_Previews: PreviewProvider {
  
  static let controller = Controller()
  static var previews: some View {
    ContentView(queryInputController: controller.queryInputController,
                hitsController: controller.hitsController)
  }
}
