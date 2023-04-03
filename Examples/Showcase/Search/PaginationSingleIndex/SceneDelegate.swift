//
//  SceneDelegate.swift
//  PaginationSingleIndex
//
//  Created by Vladislav Fitc on 01.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    let controller = PetSmartDemoSwiftUI.Controller()
    let view = PetSmartDemoSwiftUI.contentView(with: controller)
    let viewController = CommonSwiftUIDemoViewController(controller: controller, rootView: view)
    setMain(viewController, for: scene)
//    setMain(SearchDemoViewController(searchTriggeringMode: .searchAsYouType), for: scene)
  }
}
