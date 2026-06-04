//
//  SceneDelegate.swift
//  Examples
//
//  Created by Vladislav Fitc on 30/10/2021.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    let demoListViewController = DemoListViewController<Demo>(indexName: "mobile_demos")
    demoListViewController.title = "Examples"
    let pusher = ViewControllerPusher(factory: DemoViewControllerFactory(),
                                      sourceViewController: demoListViewController)
    demoListViewController.didSelect = pusher.callAsFunction

    // Persistent entry point for the experimental InstantSearchAgent demo.
    // It's surfaced here (rather than via the Algolia-driven demo list) so it
    // works without a backing demo record.
    if #available(iOS 15.0, *) {
      demoListViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: "Agent Studio",
        style: .plain,
        target: self,
        action: #selector(openAgentStudioDemo)
      )
    }

    setMain(demoListViewController, for: scene)
  }

  @available(iOS 15.0, *)
  @objc private func openAgentStudioDemo() {
    let hostingController = UIHostingController(rootView: AgentStudioDemoView())
    hostingController.title = "Agent Studio"
    (window?.rootViewController as? UINavigationController)?
      .pushViewController(hostingController, animated: true)
  }
}
