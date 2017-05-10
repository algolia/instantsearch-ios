//
//  HitsViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 19/04/2017.
//
//

import UIKit

@objc public class HitsViewController: NSObject {

    var viewModel: HitsViewModelDelegate
    
    @objc public weak var tableDataSource: HitTableViewDataSource?
    @objc public weak var tableDelegate: HitTableViewDelegate?
    @objc public weak var collectionDataSource: HitCollectionViewDataSource?
    @objc public weak var collectionDelegate: HitCollectionViewDelegate?
    
    convenience public init(table: HitsTableWidget) {
        self.init(hitsView: table)
    }
    
    convenience public init(collection: HitsCollectionWidget) {
        self.init(hitsView: collection)
    }
    
    init(hitsView: HitsViewDelegate) {
        self.viewModel = hitsView.viewModel
        super.init()
    }
}

extension HitsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hit = viewModel.hitForRow(at: indexPath)
        
        return tableDataSource?.tableView(tableView, cellForRowAt: indexPath, containing: hit) ?? UITableViewCell()
    }
}

extension HitsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hit = viewModel.hitForRow(at: indexPath)
        
        tableDelegate?.tableView(tableView, didSelectRowAt: indexPath, containing: hit)
    }
}

extension HitsViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hit = viewModel.hitForRow(at: indexPath)
        
        return collectionDataSource?.collectionView(collectionView, cellForItemAt: indexPath, containing: hit)
            ?? UICollectionViewCell()
    }
}

extension HitsViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hit = viewModel.hitForRow(at: indexPath)
        
        collectionDelegate?.collectionView(collectionView, didSelectItemAt: indexPath, containing: hit)
    }
}
