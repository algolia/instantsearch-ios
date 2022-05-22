//
//  SceneDelegate.swift
//  FilterList
//
//  Created by Vladislav Fitc on 05.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    setMain(MainViewController(), for: scene)
  }

}
