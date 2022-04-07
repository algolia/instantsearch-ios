//
//  FilterStateDebugView.swift
//  Examples
//
//  Created by Vladislav Fitc on 06.04.2022.
//

import Foundation
import SwiftUI

struct FilterStateDebugView: View {
  
  @ObservedObject var filterStateObservableController: FilterStateObservableController
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("Filters")
        .fontWeight(.heavy)
        .font(.title3)
        .padding()
      Text(filterStateObservableController.filtersString)
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
