//
//  TVSearchApp.swift
//  TVSearch
//
//  Created by Vladislav Fitc on 20/05/2022.
//

import SwiftUI

@main
struct TVSearchApp: App {

  let controller = Controller()
  var body: some Scene {
    WindowGroup {
      ContentView(searchBoxController: controller.searchBoxController,
                  hitsController: controller.hitsController)
    }
  }

}
