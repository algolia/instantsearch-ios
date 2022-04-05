//
//  SceneDelegate+Convenience.swift
//  Examples
//
//  Created by Vladislav Fitc on 04.04.2022.
//

import Foundation
import UIKit

extension SceneDelegate {

  func setMain(_ mainViewController: UIViewController, for scene: UIScene) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = UINavigationController(rootViewController: mainViewController)
    self.window = window
    window.makeKeyAndVisible()
  }

}
