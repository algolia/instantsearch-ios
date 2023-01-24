//
//  SceneDelegate.swift
//  RelevantSort
//
//  Created by Vladislav Fitc on 01.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    let viewController = RelevantSortDemoViewController()
    viewController.title = "Relevant Sort"
    setMain(viewController, for: scene)
  }
}
