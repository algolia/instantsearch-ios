//
//  ContentView.swift
//  WatchSearch WatchKit Extension
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct ContentView: View {

  @ObservedObject var searchBoxController: SearchBoxObservableController
  @ObservedObject var hitsController: HitsObservableController<Hit<Movie>>

  var body: some View {
    NavigationView {
      HitsList(hitsController) { hit, _ in
        MovieRow(movieHit: hit!)
          .frame(height: 80)
          .padding(.vertical, 3)
        Divider()
      } noResults: {
        Text("No Results")
      }
    }
    .searchable(text: $searchBoxController.query)
  }

}

struct ContentView_Previews: PreviewProvider {

  static let controller = Controller()

  static var previews: some View {
    ContentView(searchBoxController: controller.searchBoxController,
                hitsController: controller.hitsController)
    .navigationBarTitle("Algolia")

  }

}
