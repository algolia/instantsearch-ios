//
//  StoreItemsTableViewController.swift
//  Guides
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import Foundation
import UIKit
import InstantSearch

class StoreItemsTableViewController: UITableViewController, HitsController {

  var hitsSource: HitsInteractor<Hit<StoreItem>>?

  var didSelect: ((Int, Hit<StoreItem>) -> Void)?

  let cellIdentifier = "cellID"

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    setEmptyStateIfNeeded()
    return hitsSource?.numberOfHits() ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductTableViewCell else {
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
      didSelect?(indexPath.row, hit)
    }
  }

  private func setEmptyStateIfNeeded() {
    if hitsSource?.numberOfHits() ?? 0 == 0 {
      tableView.setEmptyMessage("No results")
    } else {
      tableView.restore()
    }
  }

}
