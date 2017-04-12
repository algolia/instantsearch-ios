//
//  HitsTableWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 15/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation

@objc public class HitsTableWidget: UITableView, UITableViewDataSource, HitsViewDelegate, AlgoliaView {
    
    @IBInspectable public var hitsPerPage: UInt = 20
    @IBInspectable public var infiniteScrolling: Bool = true
    @IBInspectable public var remainingItemsBeforeLoading: UInt = 5
    
    @objc public weak var hitDataSource: HitDataSource? {
        didSet {
            dataSource = self
        }
    }
    
    public var viewModel: HitsViewModelDelegate!
    
    public func scrollTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    public func reloadHits() {
        reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hit = viewModel.hitForRow(at: indexPath)
        return hitDataSource?.cellFor(hit: hit, at: indexPath) ?? UITableViewCell()
    }
}

@objc public protocol HitDataSource: class {
    func cellFor(hit: [String: Any], at indexPath: IndexPath) -> UITableViewCell
}
