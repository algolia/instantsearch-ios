//
//  UITableView+Convenience.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 20/01/2020.
//

import Foundation

#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

public extension UITableView {

  func scrollToFirstNonEmptySection() {
    (0..<numberOfSections)
      .first(where: { numberOfRows(inSection: $0) > 0 })
      .flatMap { IndexPath(row: 0, section: $0) }
      .flatMap { scrollToRow(at: $0, at: .top, animated: false) }
  }

}
#endif
