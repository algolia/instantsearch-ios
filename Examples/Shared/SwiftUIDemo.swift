//
//  SwiftUIDemo.swift
//  Examples
//
//  Created by Vladislav Fitc on 16/04/2022.
//

import Foundation
import SwiftUI
import UIKit

protocol SwiftUIDemo {

  associatedtype Controller
  associatedtype ContentView: View

  static var controller: Controller { get }
  static func contentView(with controller: Controller) -> ContentView
  static func viewController() -> UIViewController

}

extension SwiftUIDemo {

  static func viewController() -> UIViewController {
    let rootView = contentView(with: controller)
    return CommonSwiftUIDemoViewController(controller: controller,
                                           rootView: rootView)
  }

}
