//
//  ExamplesApp.swift
//  WatchSearch WatchKit Extension
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import SwiftUI

@main
struct ExamplesApp: App {
  
  let controller = Controller()
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView(searchBoxController: controller.searchBoxController,
                    hitsController: controller.hitsController)
      }
    }
  }
  
}
