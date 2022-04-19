//
//  SearchTVApp.swift
//  SearchTV
//
//  Created by Vladislav Fitc on 18/04/2022.
//

import SwiftUI

@main
struct SearchTVApp: App {
  
    let controller = Controller()
    var body: some Scene {
        WindowGroup {
          ContentView(queryInputController: controller.queryInputController,
                      hitsController: controller.hitsController)
        }
    }
}
