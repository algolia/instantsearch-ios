//
//  FilterStateDebugView.swift
//  Examples
//
//  Created by Vladislav Fitc on 06.04.2022.
//

import Foundation
import SwiftUI
import InstantSearchSwiftUI

struct FilterStateDebugView: View {

  @ObservedObject var filterStateController: FilterStateObservableController
  @ObservedObject var clearFilterController: FilterClearObservableController

  init(filterStateController: FilterStateObservableController,
       clearFilterController: FilterClearObservableController) {
    self.filterStateController = filterStateController
    self.clearFilterController = clearFilterController
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Text("Filters")
          .fontWeight(.heavy)
          .font(.title3)
        Spacer()
        Button(action: clearFilterController.clear) {
          Image(systemName: "trash.fill")
        }
      }.padding()
      Text(filterStateController.filtersString)
        .padding()
    }
    .frame(minWidth: 0,
           maxWidth: .infinity,
           alignment: .leading)
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color.black, lineWidth: 1)
    )
  }

}
