//
//  LoadingDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct LoadingDemoSwiftUI: PreviewProvider {
  
  struct ContentView: View {
    
    @ObservedObject var loadingController: LoadingObservableController
    
    var body: some View {
      VStack {
        Text("Loading")
        if #available(iOS 14.0, *) {
          if loadingController.isLoading {
            ProgressView()
          }
        }
      }
    }
    
  }
  
  static var previews: some View {
    ContentView(loadingController: .init(isLoading: true))
  }
  
}
