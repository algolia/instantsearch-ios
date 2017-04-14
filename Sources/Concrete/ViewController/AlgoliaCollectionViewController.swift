//
//  AlgoliaCollectionViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 14/04/2017.
//
//

import Foundation
import UIKit

@objc open class AlgoliaCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, HitCollectionViewDataSource, HitCollectionViewDelegate {
    
    public var hitsCollectionView: HitsCollectionWidget! {
        didSet {
            hitsCollectionView.dataSource = self
            hitsCollectionView.delegate = self
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hitsCollectionView.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.hitsCollectionView.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return self.hitsCollectionView.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, containing hit: [String : Any]) -> UICollectionViewCell {
        fatalError("Must Override cellForItem:indexpath:containing:")
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, containing hit: [String : Any]) {
        
    }
}
