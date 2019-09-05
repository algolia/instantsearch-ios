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
      guard let delegate = self else { return }

      guard let hitsSource = delegate.hitsSource else {
        fatalError("Missing hits source")
      }
      
      guard let hit: Hit = try hitsSource.hit(atIndex: row, inSection: section) else {
        return
      }

      clickHandler(tableView, hit, IndexPath(item: row, section: section))
      
    }
  }
  
}

extension MultiIndexHitsTableViewDelegate: UITableViewDelegate {
  
  open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let clickHandler = clickHandlers[indexPath.section] else {
      fatalError("No click handler found for section \(indexPath.section)")
    }
    do {
      try clickHandler(tableView, indexPath.row)
    } catch let error {
      fatalError("\(error)")
    }
  }
  
}
