//
//  SceneDelegate.swift
//  QuerySuggestionsGuide
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    setMain(QuerySuggestionsDemoViewController(), for: scene)
  }
}
