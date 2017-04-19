//
//  HitsTableController.swift
//  InstantSearch
//
//  Created by Guy Daher on 19/04/2017.
//
//

import UIKit

@objc public class HitsTableController: NSObject, UITableViewDataSource, UITableViewDelegate {

    var hitsViewDelegate: HitsViewDelegate
    
    @objc public weak var hitDataSource: HitTableViewDataSource?
    @objc public weak var hitDelegate: HitTableViewDelegate?
    
    public init(table: HitsTableWidget) {
        self.hitsViewDelegate = table
        super.init()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hitsViewDelegate.viewModel.numberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hit = hitsViewDelegate.viewModel.hitForRow(at: indexPath)
        
        return hitDataSource?.tableView(tableView, cellForRowAt: indexPath, containing: hit) ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hit = hitsViewDelegate.viewModel.hitForRow(at: indexPath)
        
        hitDelegate?.tableView(tableView, didSelectRowAt: indexPath, containing: hit)
    }
}

@objc public protocol HitTableViewDataSource: class {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String: Any]) -> UITableViewCell
}

@objc public protocol HitTableViewDelegate: class {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String: Any])
}
