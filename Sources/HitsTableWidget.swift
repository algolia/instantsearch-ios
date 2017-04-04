//
//  HitsTableWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 15/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

public class HitsTableWidget: UITableView, UITableViewDataSource, AlgoliaWidget, AlgoliaTableHitDataSource {
    
    var searcher: Searcher!
    @IBInspectable var hitsPerPage: UInt = 20
    @IBInspectable var infiniteScrolling: Bool = true
    @IBInspectable var remainingItemsBeforeLoading: UInt = 5
    
    @objc func initWith(searcher: Searcher) {
        self.searcher = searcher
        searcher.params.hitsPerPage = hitsPerPage
        dataSource = self
        
        if searcher.hits != nil {
            reloadData()
        }
    }
    
    weak var hitDataSource: HitDataSource?
    
    @objc func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        // TODO: Work on that...
        if searcher.hits != nil {
            reloadData()
        }
        
        if searcher.hits != nil && searcher.hits!.count != 0 && results?.page == 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func loadMoreIfNecessary(rowNumber: Int) {
        guard infiniteScrolling, let hits = searcher.hits else { return }
        if rowNumber + Int(remainingItemsBeforeLoading) >= hits.count {
            searcher.loadMore()
        }
    }
    
    @objc func onReset() {
        
    }
    
    func numberOfRows(in section: Int) -> Int {
        return searcher.hits?.count ?? 0
    }
    
    func hitForRow(at indexPath: IndexPath) -> [String: Any] {
        loadMoreIfNecessary(rowNumber: indexPath.row)
        return searcher.hits![indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hit = hitForRow(at: indexPath)
        return hitDataSource?.cellFor(hit: hit, at: indexPath) ?? UITableViewCell()
    }
}

protocol HitDataSource: class {
    func cellFor(hit: [String: Any], at indexPath: IndexPath) -> UITableViewCell
}

protocol AlgoliaTableHitDataSource {
    func numberOfRows(in section: Int) -> Int
    func hitForRow(at indexPath: IndexPath) -> [String: Any]
}
