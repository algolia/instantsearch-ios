//
//  RefinementTableViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 13/04/2017.
//
//

import Foundation
import UIKit

/// Base class that is meant to be inherited from a ViewController.
/// This class gives you the boilerplate needed to have a refinementList view linked to InstantSearch.
/// It imlpements the tableView dataSource and delegate protocols, 
/// and exposes the methods from `RefinementTableViewDataSource` and `RefinementTableViewDelegate`.
/// + Note: You **have** to implement the `tableView(_:cellForRowAt:containing:with:is:)` method in your class
/// to specify the layout of your refinement cells, or else you will get a fatalError.
@objc open class RefinementTableViewController: UIViewController,
    UITableViewDataSource, UITableViewDelegate, RefinementTableViewDataSource, RefinementTableViewDelegate {
    
    public var refinementTableView: RefinementTableWidget! {
        didSet {
            refinementTableViews = [refinementTableView]
        }
    }
    
    var refinementControllers: [RefinementController] = []
    
    /// Reference to the Refinement Table Widgets if there are more than one.
    public var refinementTableViews: [RefinementTableWidget] = [] {
        didSet {
            for refinementTableView in refinementTableViews {
                let refinementController = RefinementController(table: refinementTableView)
                refinementControllers.append(refinementController)
                refinementTableView.dataSource = self
                refinementTableView.delegate = self
                refinementController.tableDataSource = self
                refinementController.tableDelegate = self
            }
        }
    }
    
    // Forward the 3 important dataSource and delegate methods to the RefinementTableWidget
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableView = tableView as? RefinementTableWidget,
            let index = self.refinementTableViews.index(of: tableView) else { return 0 }
        return self.refinementControllers[index].tableView(tableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? RefinementTableWidget,
            let index = self.refinementTableViews.index(of: tableView) else { return UITableViewCell() }
        return self.refinementControllers[index].tableView(tableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableView = tableView as? RefinementTableWidget,
            let index = self.refinementTableViews.index(of: tableView) else { return }
        self.refinementControllers[index].tableView(tableView, didSelectRowAt: indexPath)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let tableView = tableView as? RefinementTableWidget,
            let index = self.refinementTableViews.index(of: tableView) else { return 0 }
        return self.refinementControllers[index].numberOfSections(in: tableView)
    }
    
    // The follow methods are to be implemented by the class extending RefinementTableViewController
    
    /// DataSource method called to specify the layout of a facet cell.
    open func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath,
                        containing facet: String,
                        with count: Int,
                        is refined: Bool) -> UITableViewCell {
        fatalError("Must Override tableView(_:cellForRowAt:containing:with:is:)")
    }
    
    /// Delegate method called when a facet cell is selected.
    open func tableView(_ tableView: UITableView,
                        didSelectRowAt indexPath: IndexPath,
                        containing facet: String,
                        with count: Int,
                        is refined: Bool) {
        
    }
}
