//
//  StoreItemsTableViewController+SearchResponse.swift
//  Examples
//
//  Created by Vladislav Fitc on 04.04.2022.
//

import Foundation
import UIKit
import InstantSearch

extension StoreItemsTableViewController {

  static func with(_ response: SearchResponse) -> Self {
    let hitsInteractor = HitsInteractor<Hit<StoreItem>>(infiniteScrolling: .off)
    hitsInteractor.update(response)
    let viewController = Self()
    hitsInteractor.connectController(viewController)
    return viewController
  }

}
