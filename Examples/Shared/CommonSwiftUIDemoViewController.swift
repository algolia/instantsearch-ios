//
//  CommonSwiftUIDemoViewController.swift
//  Examples
//
//  Created by Vladislav Fitc on 16/04/2022.
//

import Foundation
import SwiftUI

class CommonSwiftUIDemoViewController<Controller, ContentView: View>: UIHostingController<ContentView> {

  let controller: Controller

  init(controller: Controller, rootView: ContentView) {
    self.controller = controller
    super.init(rootView: rootView)
  }

  @MainActor required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
