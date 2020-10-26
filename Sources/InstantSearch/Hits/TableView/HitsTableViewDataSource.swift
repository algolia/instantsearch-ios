//
//  HitsTableViewDataSource.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

@available(*, unavailable, message: "Use your own UITableViewController conforming to HitsController protocol")
open class HitsTableViewDataSource<DataSource: HitsSource>: NSObject, UITableViewDataSource {

  public var cellConfigurator: TableViewCellConfigurator<DataSource.Record>
  public var templateCellProvider: () -> UITableViewCell
  public weak var hitsSource: DataSource?

  public init(cellConfigurator: @escaping TableViewCellConfigurator<DataSource.Record>) {
    self.cellConfigurator = cellConfigurator
    self.templateCellProvider = { return .init() }
  }

  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    guard let hitsSource = hitsSource else {
      InstantSearchLogger.missingHitsSourceWarning()
      return 0
    }

    return hitsSource.numberOfHits()

  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard let hitsSource = hitsSource else {
      InstantSearchLogger.missingHitsSourceWarning()
      return .init()
    }

    guard let hit = hitsSource.hit(atIndex: indexPath.row) else {
      return templateCellProvider()
    }

    return cellConfigurator(tableView, hit, indexPath)

  }

}
#endif
