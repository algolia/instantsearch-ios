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
    
    /// Reference to the Hits Table Widget
    public var hitsTableView: HitsTableWidget! {
        didSet {
            hitsTableViews = [hitsTableView]
        }
    }
    
    var hitsControllers: [HitsController] = []
    
    /// Reference to the Hits Table Widgets if there are more than one.
    public var hitsTableViews: [HitsTableWidget] = [] {
        didSet {
            for hitsTableView in hitsTableViews {
                let hitsController = HitsController(table: hitsTableView)
                hitsControllers.append(hitsController)
                hitsTableView.dataSource = self
                hitsTableView.delegate = self
                hitsController.tableDataSource = self
                hitsController.tableDelegate = self
            }
        }
    }
    
    // Forward the 3 important dataSource and delegate methods to the HitsTableWidget
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableView = tableView as? HitsTableWidget,
            let index = self.hitsTableViews.index(of: tableView) else { return 0 }
        
        return self.hitsControllers[index].tableView(tableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? HitsTableWidget,
            let index = self.hitsTableViews.index(of: tableView) else { return UITableViewCell() }
        
        return self.hitsControllers[index].tableView(tableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableView = tableView as? HitsTableWidget,
            let index = self.hitsTableViews.index(of: tableView) else { return }
        
        self.hitsControllers[index].tableView(tableView, didSelectRowAt: indexPath)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let tableView = tableView as? HitsTableWidget,
            let index = self.hitsTableViews.index(of: tableView) else { return 0 }
        
        return self.hitsControllers[index].numberOfSections(in: tableView)
    }
    
    // The follow methods are to be implemented by the class extending HitsTableViewController
    
    /// DataSource method called to specify the layout of a hit cell.
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String: Any]) -> UITableViewCell {
        fatalError("Must Override tableView(_:cellForRowAt:containing:)")
    }
    
    /// Delegate method called when a hit cell is selected.
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String: Any]) {
        
    }
}
