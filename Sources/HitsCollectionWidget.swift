//
//  HitsCollectionWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation

@objc public class HitsCollectionWidget: UICollectionView, UICollectionViewDataSource, HitsViewDelegate, AlgoliaView {
    
    public func initView() {
        dataSource = self
    }
    
    public func reloadHits() {
        reloadData()
    }
    
    @IBInspectable public var hitsPerPage: UInt = 20
    @IBInspectable public var infiniteScrolling: Bool = true
    @IBInspectable public var remainingItemsBeforeLoading: UInt = 5
    
    @objc public weak var hitDataSource: HitCollectionDataSource?
    
    public var viewModel: HitsViewModelDelegate!
    
    public func scrollTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hit = viewModel.hitForRow(at: indexPath)
        
        return hitDataSource?.cellFor(hit: hit, at: indexPath) ?? UICollectionViewCell()
    }
}

@objc public protocol HitCollectionDataSource: class {
    func cellFor(hit: [String: Any], at indexPath: IndexPath) -> UICollectionViewCell
}
