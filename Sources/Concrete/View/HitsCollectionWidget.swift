//
//  HitsCollectionWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation

@objc public class HitsCollectionWidget: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, HitsViewDelegate, AlgoliaView {
    
    @IBInspectable public var hitsPerPage: UInt = 20
    @IBInspectable public var infiniteScrolling: Bool = true
    @IBInspectable public var remainingItemsBeforeLoading: UInt = 5
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        dataSource = self
        delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        delegate = self
    }
    
    @objc public weak var hitDataSource: HitCollectionViewDataSource?
    @objc public weak var hitDelegate: HitCollectionViewDelegate?
    
    public var viewModel: HitsViewModelDelegate!
    
    public func scrollTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    public func reloadHits() {
        reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hit = viewModel.hitForRow(at: indexPath)
        
        return hitDataSource?.collectionView(collectionView, cellForItemAt: indexPath, containing: hit) ?? UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hit = viewModel.hitForRow(at: indexPath)
        
        hitDelegate?.collectionView(collectionView, didSelectItemAt: indexPath, containing: hit)
    }
}

@objc public protocol HitCollectionViewDataSource: class {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, containing hit: [String: Any]) -> UICollectionViewCell
}

@objc public protocol HitCollectionViewDelegate: class {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, containing hit: [String: Any])
}
