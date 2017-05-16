//
//  HitsTableViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 13/04/2017.
//
//

import Foundation
import UIKit

@objc open class HitsTableViewController: UIViewController,
    UITableViewDataSource, UITableViewDelegate, HitTableViewDataSource, HitTableViewDelegate {
    
    var hitsController: HitsController!
    
    public var hitsTableView: HitsTableWidget! {
        didSet {
            hitsController = HitsController(table: hitsTableView)
            hitsTableView.dataSource = self
            hitsTableView.delegate = self
            hitsController.tableDataSource = self
            hitsController.tableDelegate = self
        }
    }
    
    // Forward the 3 important dataSource and delegate methods to the HitsTableWidget
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hitsController.tableView(self.hitsTableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.hitsController.tableView(self.hitsTableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hitsController.tableView(self.hitsTableView, didSelectRowAt: indexPath)
    }
    
    // The follow methods are to be implemented by the class extending HitsTableViewController
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        fatalError("Must Override cellForHit:indexpath:containing:")
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String : Any]) {
        
    }
}
