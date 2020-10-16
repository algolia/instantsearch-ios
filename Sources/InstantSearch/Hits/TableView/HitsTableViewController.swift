//
//  HitsTableViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 29/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

open class HitsTableViewController<CellConfigurator: TableViewCellConfigurable>: UITableViewController, HitsController {

  public var hitsSource: HitsInteractor<CellConfigurator.Model>?

  open override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(CellConfigurator.Cell.self, forCellReuseIdentifier: CellConfigurator.cellIdentifier)
  }

  open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }

  open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: CellConfigurator.cellIdentifier, for: indexPath)
  }

  open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? CellConfigurator.Cell else { return }
    guard let model = hitsSource?.hit(atIndex: indexPath.row) else { return }
    CellConfigurator(model: model, indexPath: indexPath).configure(cell)
  }

  open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let model = hitsSource?.hit(atIndex: indexPath.row) else { return 0 }
    return CellConfigurator(model: model, indexPath: indexPath).cellHeight
  }

}
#endif
