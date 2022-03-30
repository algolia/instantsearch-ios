//
//  StatsDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct StatsDemoSwiftUI: PreviewProvider {
    
  struct ContentView: View {
    
    @ObservedObject var statsController: StatsTextObservableController
    
    var body: some View {
      Text(statsController.stats)
    }
    
  }
  
  static var previews: some View {
    ContentView(statsController: .init(stats: "100 results (5ms)"))
  }
  
}

