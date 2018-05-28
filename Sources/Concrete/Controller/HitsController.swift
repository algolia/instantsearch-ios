//
//  HitsController.swift
//  InstantSearch
//
//  Created by Guy Daher on 19/04/2017.
//
//

import UIKit

/// A controller object that manages a Hits Widget.
/// It takes care of interacting with InstantSearch and offer clear and easy to use dataSource and delegate methods.
/// - tableDataSource: DataSource to specify the layout of a table hit cell.
/// - tableDelegate: Delegate to specify the behavior when a table hit cell is selected.
/// - collectionDataSource: DataSource to specify the layout of a collection hit cell.
/// - collectionDelegate: Delegate to specify the behavior when a collection hit cell is selected.
@objcMembers public class HitsController: NSObject {
    
    /// Reference to the viewModel associated with the hits widget.
    var viewModel: HitsViewModelDelegate
    
    /// DataSource that takes care of the content of the table hits widget.
    @objc public weak var tableDataSource: HitsTableViewDataSource?
    
    /// Delegate that takes care of the behavior of the table hits widget.
    @objc public weak var tableDelegate: HitsTableViewDelegate?
    
    /// DataSource that takes care of the content of the collection hits widget.
    @objc public weak var collectionDataSource: HitsCollectionViewDataSource?
    
    /// Delegate that takes care of the behavior of the collection hits widget.
    @objc public weak var collectionDelegate: HitsCollectionViewDelegate?
    
    @objc convenience public init(table: HitsTableWidget) {
        self.init(hitsView: table)
    }
    
    @objc convenience public init(collection: HitsCollectionWidget) {
        self.init(hitsView: collection)
    }
    
    @objc init(hitsView: HitsViewDelegate) {
        self.viewModel = hitsView.viewModel
        super.init()
    }
}

extension HitsController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hit = viewModel.hitForRow(at: indexPath)
        
        return tableDataSource?.tableView(tableView, cellForRowAt: indexPath, containing: hit) ?? UITableViewCell()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if viewModel.numberOfRows() > 0 {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        } else {
            tableView.separatorStyle  = .none
            
            if let noResultView = tableDataSource?.viewForNoResults?(in: tableView) {
                tableView.backgroundView  = noResultView
            } else { // Default view
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                                 width: tableView.bounds.size.width,
                                                                 height: tableView.bounds.size.height))
                noDataLabel.text          = "No results available"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
            }
        }
        return numOfSections
    }
}

extension HitsController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hit = viewModel.hitForRow(at: indexPath)
        
        tableDelegate?.tableView(tableView, didSelectRowAt: indexPath, containing: hit)
    }
}

extension HitsController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hit = viewModel.hitForRow(at: indexPath)
        
        return collectionDataSource?.collectionView(collectionView, cellForItemAt: indexPath, containing: hit)
            ?? UICollectionViewCell()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        
        if viewModel.numberOfRows() > 0 {
            numOfSections            = 1
            collectionView.backgroundView = nil
        } else {
            if let noResultView = collectionDataSource?.viewForNoResults?(in: collectionView) {
                collectionView.backgroundView  = noResultView
            } else { // Default View
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                                 width: collectionView.bounds.size.width,
                                                                 height: collectionView.bounds.size.height))
                noDataLabel.text          = "No results available"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                collectionView.backgroundView  = noDataLabel
            }
        }
        return numOfSections
        
    }
}

extension HitsController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hit = viewModel.hitForRow(at: indexPath)
        
        collectionDelegate?.collectionView(collectionView, didSelectItemAt: indexPath, containing: hit)
    }
}
