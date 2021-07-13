//
//  ItemController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 31/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol ItemController: AnyObject {

  associatedtype Item

  func setItem(_ item: Item)
  func invalidate()

}

public extension ItemController {

  func invalidate() {
  }

}
