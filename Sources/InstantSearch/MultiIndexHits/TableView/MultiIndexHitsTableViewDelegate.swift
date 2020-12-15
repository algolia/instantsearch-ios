//
//  MultiIndexHitsTableViewDelegate.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

@available(*, unavailable, message: "Use your own UITableViewController conforming to MultiIndexHitsController protocol")
open class MultiIndexHitsTableViewDelegate: NSObject, UITableViewDelegate {

  typealias ClickHandler = (UITableView, Int) throws -> Void

  public weak var hitsSource: MultiIndexHitsSource?

  private var clickHandlers: [Int: ClickHandler]

  public override init() {
    clickHandlers = [:]
    super.init()
  }

  public func setClickHandler<Hit: Codable>(forSection section: Int, _ clickHandler: @escaping TableViewClickHandler<Hit>) {
    clickHandlers[section] = { [weak self] (tableView, row) in
      guard let delegate = self else { return }

      guard let hitsSource = delegate.hitsSource else {
        InstantSearchLogger.missingHitsSourceWarning()
        return
      }

      guard let hit: Hit = try hitsSource.hit(atIndex: row, inSection: section) else {
        return
      }

      clickHandler(tableView, hit, IndexPath(item: row, section: section))

    }
  }

  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let clickHandler = clickHandlers[indexPath.section] else {
      InstantSearchLogger.missingClickHandlerWarning(forSection: indexPath.section)
      return
    }
    do {
      try clickHandler(tableView, indexPath.row)
    } catch let underlyingError {
      InstantSearchLogger.error(underlyingError)
      return
    }
  }

}
#endif
