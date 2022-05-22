//
//  ViewControllerPusher.swift
//  Examples
//
//  Created by Vladislav Fitc on 05.04.2022.
//

import Foundation
import UIKit

final class ViewControllerPusher<Factory: ViewControllerFactory> {

  let factory: Factory
  let sourceViewController: UIViewController
  var isTransitionAnimated: Bool
  var missingNavigationControllerMessage: String?
  var missingModelMessage: ((Factory.Model) -> String)?

  init(factory: Factory, sourceViewController: UIViewController) {
    self.factory = factory
    self.sourceViewController = sourceViewController
    self.isTransitionAnimated = true
  }

  func callAsFunction(_ model: Factory.Model) {
    func presentErrorAlert(withMessage message: String?) {
      let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
      sourceViewController.present(alertController, animated: isTransitionAnimated)
    }
    guard let navigationController = sourceViewController.navigationController else {
      presentErrorAlert(withMessage: missingNavigationControllerMessage)
      return
    }
    guard let destinationViewController = factory.viewController(for: model) else {
      presentErrorAlert(withMessage: missingModelMessage?(model))
      return
    }
    navigationController.pushViewController(destinationViewController, animated: isTransitionAnimated)
  }

}
