//
//  MultiIndexHitsTableViewDataSource.swift
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
  @available(*, deprecated, message: "Use your own UITableViewController conforming to MultiIndexHitsController protocol")
  open class MultiIndexHitsTableViewDataSource: NSObject, UITableViewDataSource {
    private typealias CellConfigurator = (UITableView, Int) throws -> UITableViewCell

    public weak var hitsSource: MultiIndexHitsSource?

    private var cellConfigurators: [Int: CellConfigurator]

    override public init() {
      cellConfigurators = [:]
      super.init()
    }

    public func setCellConfigurator<Hit: Codable>(forSection section: Int,
                                                  templateCellProvider: @escaping () -> UITableViewCell = { return .init() },
                                                  _ cellConfigurator: @escaping TableViewCellConfigurator<Hit>) {
      cellConfigurators[section] = { [weak self] tableView, row in

        guard let hitsSource = self?.hitsSource else {
          InstantSearchLog.missingHitsSourceWarning()
          return .init()
        }

        guard let hit: Hit = try hitsSource.hit(atIndex: row, inSection: section) else {
          return templateCellProvider()
        }

        return cellConfigurator(tableView, hit, IndexPath(row: row, section: section))
      }
    }

    open func numberOfSections(in _: UITableView) -> Int {
      guard let hitsSource = hitsSource else {
        InstantSearchLog.missingHitsSourceWarning()
        return 0
      }
      return hitsSource.numberOfSections()
    }

    open func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let hitsSource = hitsSource else {
        InstantSearchLog.missingHitsSourceWarning()
        return 0
      }
      return hitsSource.numberOfHits(inSection: section)
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cellConfigurator = cellConfigurators[indexPath.section] else {
        InstantSearchLog.missingCellConfiguratorWarning(forSection: indexPath.section)
        return .init()
      }
      do {
        return try cellConfigurator(tableView, indexPath.row)
      } catch let underlyingError {
        InstantSearchLog.error(underlyingError)
        return .init()
      }
    }
  }
#endif
