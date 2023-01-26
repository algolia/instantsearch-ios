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

    override open func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(CellConfigurator.Cell.self, forCellReuseIdentifier: CellConfigurator.cellIdentifier)
    }

    override open func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
      return hitsSource?.numberOfHits() ?? 0
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return tableView.dequeueReusableCell(withIdentifier: CellConfigurator.cellIdentifier, for: indexPath)
    }

    override open func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      guard let cell = cell as? CellConfigurator.Cell else { return }
      guard let model = hitsSource?.hit(atIndex: indexPath.row) else { return }
      CellConfigurator(model: model, indexPath: indexPath).configure(cell)
    }

    override open func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      guard let model = hitsSource?.hit(atIndex: indexPath.row) else { return 0 }
      return CellConfigurator(model: model, indexPath: indexPath).cellHeight
    }
  }
#endif
