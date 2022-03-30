//
//  ClearFiltersDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct ClearFiltersDemoSwiftUI: PreviewProvider {
  
  struct ContentView: View {
    
    @ObservedObject var filterClearController: FilterClearObservableController
    
    var body: some View {
      Button("Clear filters") {
        filterClearController.clear()
      }
    }
    
  }
  
  static var previews: some View {
    ContentView(filterClearController: .init())
  }
  
}
