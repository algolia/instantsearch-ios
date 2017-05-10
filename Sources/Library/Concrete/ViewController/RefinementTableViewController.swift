//
//  RefinementTableViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 13/04/2017.
//
//

import Foundation
import UIKit

@objc open class RefinementTableViewController: UIViewController,
    UITableViewDataSource, UITableViewDelegate, RefinementTableViewDataSource, RefinementTableViewDelegate {
    
    var refinementViewController: RefinementViewController!
    
    public var refinementTableView: RefinementTableWidget! {
        didSet {
            refinementViewController = RefinementViewController(table: refinementTableView)
            refinementTableView.dataSource = self
            refinementTableView.delegate = self
            refinementViewController.tableDataSource = self
            refinementViewController.tableDelegate = self
        }
    }
    
    // Forward the 3 important dataSource and delegate methods to the HitsTableWidget
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.refinementViewController.tableView(self.refinementTableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.refinementViewController.tableView(self.refinementTableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.refinementViewController.tableView(self.refinementTableView, didSelectRowAt: indexPath)
    }
    
    // The follow methods are to be implemented by the class extending HitsTableViewController
    
    open func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath,
                        containing facet: String,
                        with count: Int,
                        is refined: Bool) -> UITableViewCell {
        fatalError("Must Override cellForHit:indexpath:containing:with:is:")
    }
    
    open func tableView(_ tableView: UITableView,
                        didSelectRowAt indexPath: IndexPath,
                        containing facet: String,
                        with count: Int,
                        is refined: Bool) {
        
    }
}
