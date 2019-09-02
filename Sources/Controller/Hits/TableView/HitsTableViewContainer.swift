//
//  HitsTableViewContainer.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/09/2019.
//

import Foundation
import UIKit

public protocol HitsTableViewContainer {
  
  var hitsTableView: UITableView { get }
  
}

public extension HitsController where Self: HitsTableViewContainer {
  
  func reload() {
    hitsTableView.reloadData()
  }
  
  func scrollToTop() {
    guard hitsTableView.numberOfRows(inSection: 0) != 0 else { return }
    let indexPath = IndexPath(row: 0, section: 0)
    self.hitsTableView.scrollToRow(at: indexPath, at: .top, animated: false)
  }
  
}

public extension MultiIndexHitsController where Self: HitsTableViewContainer {
  
  func reload() {
    hitsTableView.reloadData()
  }
  
  func scrollToTop() {
    guard hitsTableView.numberOfRows(inSection: 0) != 0 else { return }
    let indexPath = IndexPath(item: 0, section: 0)
    hitsTableView.scrollToRow(at: indexPath, at: .top, animated: false)
  }
  
}
