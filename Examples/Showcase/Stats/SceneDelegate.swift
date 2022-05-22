//
//  SceneDelegate.swift
//  Stats
//
//  Created by Vladislav Fitc on 04.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    setMain(StatsDemoViewController(), for: scene)
  }

}
