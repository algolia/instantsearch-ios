//
//  ContentView.swift
//  TVSearch
//
//  Created by Vladislav Fitc on 20/05/2022.
//

import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct ContentView: View {

  @ObservedObject var searchBoxController: SearchBoxObservableController
  @ObservedObject var hitsController: HitsObservableController<Hit<Movie>>

  var body: some View {
    HitsList(hitsController) { hit, _ in
      MovieRow(movieHit: hit!)
        .padding(.bottom, 10)
        .focusable(true)
      Divider()
    } noResults: {
      Text("No Results")
    }
    .searchable(text: $searchBoxController.query)
  }

}

struct ContentView_Previews: PreviewProvider {

  static let controller = Controller()
  static var previews: some View {
    ContentView(searchBoxController: controller.searchBoxController,
                hitsController: controller.hitsController)
  }
}
