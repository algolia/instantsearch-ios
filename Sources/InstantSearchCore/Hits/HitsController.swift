//
//  HitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 23/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol HitsController: AnyObject, Reloadable {

  associatedtype DataSource: HitsSource

  var hitsSource: DataSource? { get set }

  func scrollToTop()

}

public extension HitsController {

  func scrollToTop() {}
  func reload() {}

}
