//
//  HitsTableViewDelegate.swift
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
open class HitsTableViewDelegate<DataSource: HitsSource>: NSObject, UITableViewDelegate {

  public var clickHandler: TableViewClickHandler<DataSource.Record>
  public weak var hitsSource: DataSource?

  public init(clickHandler: @escaping TableViewClickHandler<DataSource.Record>) {
    self.clickHandler = clickHandler
  }

  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    guard let hitsSource = hitsSource else {
      InstantSearchLogger.missingHitsSourceWarning()
      return
    }

    guard let hit = hitsSource.hit(atIndex: indexPath.row) else {
      return
    }
    clickHandler(tableView, hit, indexPath)

  }

}
#endif
