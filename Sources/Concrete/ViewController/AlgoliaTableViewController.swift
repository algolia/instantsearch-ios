//
//  AlgoliaTableViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 13/04/2017.
//
//

import Foundation
import UIKit

class AlgoliaTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HitDataSource {
    
    open var tableView: HitsTableWidget! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.tableView(self.tableView, numberOfRowsInSection: section)
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableView.tableView(self.tableView, cellForRowAt: indexPath)
    }
    
    open func cellFor(hit: [String : Any], at indexPath: IndexPath) -> UITableViewCell {
        fatalError("Must Override cellForHit:indexpath")
    }
}
