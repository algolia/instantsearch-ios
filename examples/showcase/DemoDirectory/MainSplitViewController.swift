//
//  MainSplitViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 09/06/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit

class MainSplitViewController: UISplitViewController {
  
  let demoListNavigationController: UINavigationController
  let demoListViewController: DemoListViewController
  let demoFactory: DemoFactory
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    demoListViewController = .init(nibName: nil, bundle: nil)
    demoFactory = .init()
    demoListNavigationController = UINavigationController(rootViewController: demoListViewController)
    demoListNavigationController.navigationBar.prefersLargeTitles = true
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    demoListViewController.title = "Demo Directory"
    demoListViewController.delegate = self
    viewControllers = [demoListNavigationController]
  }
  
}

extension MainSplitViewController: DemoListViewControllerDelegate {
  
  func demoListViewController(_ demoListViewController: DemoListViewController, didSelect demo: Demo) {
    do {
      let viewController = try demoFactory.viewController(for: demo, using: .SwiftUI)
      let navigationController = UINavigationController(rootViewController: viewController)
      showDetailViewController(navigationController, sender: self)
    } catch let error as DemoFactory.Error {
      switch error {
      case .demoNotImplemented:
            let notImplementedAlertController = UIAlertController(title: nil, message: "This demo is not implemented yet", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: .none)
            notImplementedAlertController.addAction(okAction)
            present(notImplementedAlertController, animated: true, completion: .none)
      }
    } catch let error {
      print("\(error)")
    }

  }
  
}
