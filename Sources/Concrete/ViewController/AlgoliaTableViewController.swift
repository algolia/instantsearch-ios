//
//  AlgoliaTableViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 13/04/2017.
//
//

import Foundation
import UIKit

@objc open class AlgoliaTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HitTableViewDataSource, HitTableViewDelegate {
    
    public var hitsTableView: HitsTableWidget! {
        didSet {
            hitsTableView.dataSource = self
            hitsTableView.delegate = self
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hitsTableView.tableView(self.hitsTableView, numberOfRowsInSection: section)
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.hitsTableView.tableView(self.hitsTableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hitsTableView.tableView(self.hitsTableView, didSelectRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        fatalError("Must Override cellForHit:indexpath")
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String : Any]) {
        
    }
}
