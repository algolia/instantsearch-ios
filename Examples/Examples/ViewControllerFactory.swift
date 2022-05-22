//
//  ViewControllerFactory.swift
//  Examples
//
//  Created by Vladislav Fitc on 05.04.2022.
//

import Foundation
import UIKit

protocol ViewControllerFactory {

  associatedtype Model

  func viewController(for model: Model) -> UIViewController?

}
