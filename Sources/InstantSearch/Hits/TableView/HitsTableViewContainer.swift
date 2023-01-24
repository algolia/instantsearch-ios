//
//  HitsTableViewContainer.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 02/09/2019.
//

#if !InstantSearchCocoaPods
  import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
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
      hitsTableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
  }

  @available(*, deprecated, message: "Use multiple HitsSearcher aggregated with MultiSearcher instead of MultiIndexSearcher")
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
#endif
