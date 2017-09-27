//
//  HitsTableViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 13/04/2017.
//
//

import Foundation
import UIKit

/// Base class that is meant to be inherited from a ViewController.
/// This class gives you the boilerplate needed to have a hits view linked to InstantSearch.
/// It imlpements the tableView dataSource and delegate protocols, 
/// and exposes the methods from `HitsTableViewDataSource` and `HitsTableViewDelegate`.
/// + Note: You **have** to implement the `tableView(_:cellForRowAt:containing:)` method in your class
/// to specify the layout of your hit cells, or else you will get a fatalError.
@objc open class HitsTableViewController: UIViewController,
    UITableViewDataSource, UITableViewDelegate, HitsTableViewDataSource, HitsTableViewDelegate {
    
    var hitsController: HitsController!
    
    /// Reference to the Hits Table Widget
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
        return self.hitsController.tableView(tableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.hitsController.tableView(tableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hitsController.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.hitsController.numberOfSections(in: tableView)
    }
    
    // The follow methods are to be implemented by the class extending HitsTableViewController
    
    /// DataSource method called to specify the layout of a hit cell.
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        fatalError("Must Override tableView(_:cellForRowAt:containing:)")
    }
    
    /// Delegate method called when a hit cell is selected.
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String : Any]) {
        
    }
}
