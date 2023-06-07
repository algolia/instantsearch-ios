//
//  SceneDelegate.swift
//  QuerySuggestionsGuide
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import UIKit
import SwiftUI
import InstantSearchCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    let uikitViewController = QuerySuggestionsDemoViewController()
    let swiftUIViewController = UIHostingController(rootView: SearchView())
    setMain(swiftUIViewController, for: scene)
  }
}
