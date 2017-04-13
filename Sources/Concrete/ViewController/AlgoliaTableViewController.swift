//
//  AlgoliaTableViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 13/04/2017.
//
//

import Foundation
import UIKit

@objc open class AlgoliaTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HitDataSource {
    
    open var hitsTableView: HitsTableWidget! {
        didSet {
            hitsTableView.dataSource = self
            hitsTableView.delegate = self
            hitsTableView.hitDataSource = self
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hitsTableView.tableView(self.hitsTableView, numberOfRowsInSection: section)
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.hitsTableView.tableView(self.hitsTableView, cellForRowAt: indexPath)
    }
    
    open func cellFor(hit: [String : Any], at indexPath: IndexPath) -> UITableViewCell {
        fatalError("Must Override cellForHit:indexpath")
    }
}
