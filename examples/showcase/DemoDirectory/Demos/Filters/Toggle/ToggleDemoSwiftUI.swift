//
//  ToggleDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 01/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct ToggleDemoSwiftUI: PreviewProvider {
  
  struct ContentView: View {
    
    @ObservedObject var toggleController: FilterToggleObservableController<Filter.Tag>
    
    var body: some View {
      Toggle(toggleController.filter?.description ?? "No filter",
             isOn: $toggleController.isSelected).padding()
    }
    
  }
  
  static var previews: some View {
    ContentView(toggleController: .init(filter: "On Sale", isSelected: true))
  }
  
}
