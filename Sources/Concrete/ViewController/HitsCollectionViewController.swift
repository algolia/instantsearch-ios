//
//  HitsCollectionViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 14/04/2017.
//
//

import Foundation
import UIKit

@objc open class HitsCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, HitCollectionViewDataSource, HitCollectionViewDelegate {
    
    var hitsViewController: HitsViewController!
    
    public var hitsCollectionView: HitsCollectionWidget! {
        didSet {
            hitsViewController = HitsViewController(collection: hitsCollectionView)
            hitsCollectionView.dataSource = self
            hitsCollectionView.delegate = self
            hitsViewController.collectionDataSource = self
            hitsViewController.collectionDelegate = self
        }
    }
    
    // Forward the 3 important dataSource and delegate methods to the HitsCollectionWidget
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hitsViewController.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.hitsViewController.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return self.hitsViewController.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    // The follow methods are to be implemented by the class extending HitsCollectionViewController
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, containing hit: [String : Any]) -> UICollectionViewCell {
        fatalError("Must Override cellForItem:indexpath:containing:")
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, containing hit: [String : Any]) {
        
    }
}
