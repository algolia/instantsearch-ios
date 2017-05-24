//
//  RefinementCollectionViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 13/04/2017.
//
//

import Foundation
import UIKit

@objc open class RefinementCollectionViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate, RefinementCollectionViewDataSource, RefinementCollectionViewDelegate {
    
    var refinementController: RefinementController!
    
    /// Reference to the Refinement Collection Widget
    public var refinementCollectionView: RefinementCollectionWidget! {
        didSet {
            refinementController = RefinementController(collection: refinementCollectionView)
            refinementCollectionView.dataSource = self
            refinementCollectionView.delegate = self
            refinementController.collectionDataSource = self
            refinementController.collectionDelegate = self
        }
    }
    
    // Forward the 3 important dataSource and delegate methods to the HitsCollectionWidget
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.refinementController.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.refinementController.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.refinementController.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.refinementController.numberOfSections(in: collectionView)
    }
    
    // The follow methods are to be implemented by the class extending HitsCollectionViewController
    
    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath,
                             containing facet: String,
                             with count: Int,
                             is refined: Bool) -> UICollectionViewCell {
        fatalError("Must Override cellForHit:indexpath:containing:with:is:")
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             didSelectItemAt indexPath: IndexPath,
                             containing facet: String,
                             with count: Int,
                             is refined: Bool) {
        
    }
}
