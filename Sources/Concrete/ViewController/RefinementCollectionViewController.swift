//
//  RefinementCollectionViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 13/04/2017.
//
//

import Foundation
import UIKit

@objc open class RefinementCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RefinementCollectionViewDataSource, RefinementCollectionViewDelegate {
    
    var refinementViewController: RefinementViewController!
    
    public var refinementCollectionView: RefinementCollectionWidget! {
        didSet {
            refinementViewController = RefinementViewController(collection: refinementCollectionView)
            refinementCollectionView.dataSource = self
            refinementCollectionView.delegate = self
            refinementViewController.collectionDataSource = self
            refinementViewController.collectionDelegate = self
        }
    }
    
    // Forward the 3 important dataSource and delegate methods to the HitsCollectionWidget
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.refinementViewController.collectionView(self.refinementCollectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.refinementViewController.collectionView(self.refinementCollectionView, cellForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.refinementViewController.collectionView(self.refinementCollectionView, didSelectItemAt: indexPath)
    }
    
    // The follow methods are to be implemented by the class extending HitsCollectionViewController
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) -> UICollectionViewCell {
        fatalError("Must Override cellForHit:indexpath:containing:with:is:")
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, containing hit: [String : Any]) {
        
    }
}
