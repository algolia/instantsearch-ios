//
//  WatchSearchApp.swift
//  WatchSearch WatchKit Extension
//
//  Created by Vladislav Fitc on 20/05/2022.
//

import SwiftUI

@main
struct WatchSearchApp: App {

  let controller = Controller()

  @SceneBuilder var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView(searchBoxController: controller.searchBoxController,
                    hitsController: controller.hitsController)
      }
    }

    WKNotificationScene(controller: NotificationController.self, category: "myCategory")
  }
}
