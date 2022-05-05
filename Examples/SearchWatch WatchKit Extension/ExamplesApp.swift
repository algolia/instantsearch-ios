//
//  ExamplesApp.swift
//  SearchWatch WatchKit Extension
//
//  Created by Vladislav Fitc on 18/04/2022.
//

import SwiftUI
import InstantSearchSwiftUI

@main
struct ExamplesApp: App {
    
    let controller = Controller()
  
    var body: some Scene {
        WindowGroup {
            NavigationView {
              ContentView(queryInputController: controller.queryInputController,
                          hitsController: controller.hitsController)
            }
        }
    }
}
