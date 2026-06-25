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
    // Surface the experimental InstantSearchAgent demo as the last section of
    // the demo list. It's a static entry (no backing Algolia record).
    demoListViewController.extraSections = [(groupName: "Experimental", demos: Demo.experimental)]
    let pusher = ViewControllerPusher(factory: DemoViewControllerFactory(),
                                      sourceViewController: demoListViewController)
    demoListViewController.didSelect = pusher.callAsFunction

    setMain(demoListViewController, for: scene)
  }
}
