//
//  SceneDelegate.swift
//  CategoriesHits
//
//  Created by Vladislav Fitc on 19/11/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    setMain(CategoriesHits.SearchViewController(), for: scene)
  }

}
