//
//  MultiHitsController.swift
//  InstantSearch
//
//  Created by Guy Daher on 27/11/2017.
//
//

import UIKit

/// A controller object that manages a Hits Widget.
/// It takes care of interacting with InstantSearch and offer clear and easy to use dataSource and delegate methods.
/// - tableDataSource: DataSource to specify the layout of a table hit cell.
/// - tableDelegate: Delegate to specify the behavior when a table hit cell is selected.
/// - collectionDataSource: DataSource to specify the layout of a collection hit cell.
/// - collectionDelegate: Delegate to specify the behavior when a collection hit cell is selected.
@objcMembers public class MultiHitsController: NSObject {
    
    /// Reference to the viewModel associated with the hits widget.
    var viewModel: MultiHitsViewModelDelegate
    
    /// DataSource that takes care of the content of the table hits widget.
    @objc public weak var tableDataSource: HitsTableViewDataSource?
    
    /// Delegate that takes care of the behavior of the table hits widget.
    @objc public weak var tableDelegate: HitsTableViewDelegate?
    
    /// DataSource that takes care of the content of the collection hits widget.
    @objc public weak var collectionDataSource: HitsCollectionViewDataSource?
    
    /// Delegate that takes care of the behavior of the collection hits widget.
    @objc public weak var collectionDelegate: HitsCollectionViewDelegate?
    
    @objc convenience public init(table: MultiHitsTableWidget) {
        self.init(hitsView: table)
    }
    
    @objc convenience public init(collection: MultiHitsCollectionWidget) {
        self.init(hitsView: collection)
    }
    
    @objc init(hitsView: MultiHitsViewDelegate) {
        self.viewModel = hitsView.viewModel
        super.init()
    }
}

extension MultiHitsController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hit = viewModel.hitForRow(at: indexPath)
        
        return tableDataSource?.tableView(tableView, cellForRowAt: indexPath, containing: hit) ?? UITableViewCell()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel.numberOfSections()
    }
}

extension MultiHitsController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hit = viewModel.hitForRow(at: indexPath)
        
        tableDelegate?.tableView(tableView, didSelectRowAt: indexPath, containing: hit)
    }
}

extension MultiHitsController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hit = viewModel.hitForRow(at: indexPath)
        
        return collectionDataSource?.collectionView(collectionView, cellForItemAt: indexPath, containing: hit)
            ?? UICollectionViewCell()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
}

extension MultiHitsController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hit = viewModel.hitForRow(at: indexPath)
        
        collectionDelegate?.collectionView(collectionView, didSelectItemAt: indexPath, containing: hit)
    }
}
