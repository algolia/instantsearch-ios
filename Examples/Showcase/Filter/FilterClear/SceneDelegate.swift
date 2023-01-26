//
//  SceneDelegate.swift
//  FilterClear
//
//  Created by Vladislav Fitc on 01.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    setMain(ClearFiltersDemoViewController(), for: scene)
  }
}
