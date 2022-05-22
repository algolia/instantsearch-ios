//
//  MediaDemoApp.swift
//  MediaDemo
//
//  Created by Vladislav Fitc on 09/05/2022.
//

import SwiftUI

@main
struct MediaDemoApp: App {

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
