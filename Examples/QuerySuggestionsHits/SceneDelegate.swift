//
//  SceneDelegate.swift
//  QuerySuggestionsHits
//
//  Created by Vladislav Fitc on 04/11/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    setMain(QuerySuggestionsAndHits.SearchViewController(), for: scene)
  }
}
