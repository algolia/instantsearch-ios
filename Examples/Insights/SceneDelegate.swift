//
//  SceneDelegate.swift
//  Insights
//
//  Created by Vladislav Fitc on 05/05/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    setMain(InsightsViewController(), for: scene)
  }

}
