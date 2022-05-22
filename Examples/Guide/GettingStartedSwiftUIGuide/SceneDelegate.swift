//
//  SceneDelegate.swift
//  GettingStartedSwiftUIGuide
//
//  Created by Vladislav Fitc on 01.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    let controller = AlgoliaController()
    let rootView = ContentView(searchBoxController: controller.searchBoxController,
                               hitsController: controller.hitsController,
                               statsController: controller.statsController,
                               facetListController: controller.facetListController)
    let viewController = CommonSwiftUIDemoViewController(controller: controller,
                                                         rootView: rootView)
    setMain(viewController, for: scene)
  }

}
