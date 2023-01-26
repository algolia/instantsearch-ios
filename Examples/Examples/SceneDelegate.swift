//
//  SceneDelegate.swift
//  Examples
//
//  Created by Vladislav Fitc on 30/10/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    let demoListViewController = DemoListViewController<Demo>(indexName: "mobile_demos")
    demoListViewController.title = "Examples"
    let pusher = ViewControllerPusher(factory: DemoViewControllerFactory(),
                                      sourceViewController: demoListViewController)
    demoListViewController.didSelect = pusher.callAsFunction
    setMain(demoListViewController, for: scene)
  }
}
