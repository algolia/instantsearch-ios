//
//  HitsTableWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 15/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

@objc public class HitsTableWidget: UITableView, UITableViewDataSource, AlgoliaOutputWidget, AlgoliaTableHitDataSource {
    
    public var searcher: Searcher! {
        didSet {
            searcher.params.hitsPerPage = hitsPerPage
            dataSource = self
            
            if searcher.hits.count > 0 {
                reloadData()
            }
        }
    }
    
    @IBInspectable var hitsPerPage: UInt = 20
    @IBInspectable var infiniteScrolling: Bool = true
    @IBInspectable var remainingItemsBeforeLoading: UInt = 5
    
    @objc public weak var hitDataSource: HitDataSource?
    
    @objc public func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        guard searcher.hits.count > 0 else { return }
        
        reloadData()
        
        if results?.page == 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func loadMoreIfNecessary(rowNumber: Int) {
        guard infiniteScrolling else { return }
        if rowNumber + Int(remainingItemsBeforeLoading) >= searcher.hits.count {
            searcher.loadMore()
        }
    }
    
    public func numberOfRows(in section: Int) -> Int {
        return searcher.hits.count
    }
    
    public func hitForRow(at indexPath: IndexPath) -> [String: Any] {
        loadMoreIfNecessary(rowNumber: indexPath.row)
        return searcher.hits[indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hit = hitForRow(at: indexPath)
        return hitDataSource?.cellFor(hit: hit, at: indexPath) ?? UITableViewCell()
    }
}

@objc public protocol HitDataSource: class {
    func cellFor(hit: [String: Any], at indexPath: IndexPath) -> UITableViewCell
}

@objc public protocol AlgoliaTableHitDataSource {
    func numberOfRows(in section: Int) -> Int
    func hitForRow(at indexPath: IndexPath) -> [String: Any]
}
