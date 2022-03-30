//
//  EcomHitsTableViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 21/03/2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class StoreItemsTableViewController: UITableViewController, HitsController {
    
  let cellIdentifier = "cellID"
  
  var hitsSource: HitsInteractor<Hit<StoreItem>>?
  
  var didSelect: ((Hit<StoreItem>) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(StoreItemTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }
    
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let hitsCount = hitsSource?.numberOfHits() ?? 0
    if hitsCount == 0 {
      tableView.setEmptyMessage("No results")
    } else {
      tableView.restore()
    }
    return hitsCount
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StoreItemTableViewCell else {
      return UITableViewCell()
    }
    guard let hit = hitsSource?.hit(atIndex: indexPath.row) else {
      return cell
    }
    cell.setup(with: hit)
    return cell
  }
    
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let hit = hitsSource?.hit(atIndex: indexPath.row) {
      didSelect?(hit)
    }
  }
    
}

extension StoreItemsTableViewController {
  
  static func with(_ response: SearchResponse) -> Self {
    let hitsInteractor = HitsInteractor<Hit<StoreItem>>(infiniteScrolling: .off)
    hitsInteractor.update(response)
    let viewController = Self()
    hitsInteractor.connectController(viewController)
    return viewController
  }
  
}
