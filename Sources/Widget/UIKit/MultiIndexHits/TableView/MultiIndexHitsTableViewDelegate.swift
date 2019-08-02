//
//  MultiIndexHitsTableViewDelegate.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/08/2019.
//

import Foundation
import UIKit

open class MultiIndexHitsTableViewDelegate: NSObject {
  
  typealias ClickHandler = (UITableView, Int) throws -> Void
  
  public weak var hitsSource: MultiIndexHitsSource?
  
  private var clickHandlers: [Int: ClickHandler]
  
  public override init() {
    clickHandlers = [:]
    super.init()
  }
  
  public func setClickHandler<Hit: Codable>(forSection section: Int, _ clickHandler: @escaping TableViewClickHandler<Hit>) {
    clickHandlers[section] = { [weak self] (tableView, row) in
      guard let hit: Hit = try self?.hitsSource?.hit(atIndex: row, inSection: section) else {
        assertionFailure("Invalid state: Attempt to process a click of a cell for a missing hit in a hits Interactor")
        return
      }
      clickHandler(tableView, hit, IndexPath(row: row, section: section))
    }
  }
  
}

extension MultiIndexHitsTableViewDelegate: UITableViewDelegate {
  
  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    do {
      try clickHandlers[indexPath.section]?(tableView, indexPath.row)
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}
