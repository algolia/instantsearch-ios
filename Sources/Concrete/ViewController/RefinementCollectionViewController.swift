//
//  RefinementCollectionViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 13/04/2017.
//
//

import Foundation
import UIKit

/// Base class that is meant to be inherited from a ViewController.
/// This class gives you the boilerplate needed to have a refinement view linked to InstantSearch.
/// It imlpements the collectionView dataSource and delegate protocols, 
/// and exposes the methods from `RefinementCollectionViewDataSource` and `RefinementCollectionViewDelegate`.
/// + Note: You **have** to implement the `collectionView(_:cellForItemAt:containing:with:is:)` method in your class
/// to specify the layout of your refinement cells, or else you will get a fatalError.
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
    
    /// DataSource method called to specify the layout of a facet cell.
    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath,
                             containing facet: String,
                             with count: Int,
                             is refined: Bool) -> UICollectionViewCell {
        fatalError("Must Override collectionView(_:cellForItemAt:containing:with:is:)")
    }
    
    /// Delegate method called when a facet cell is selected.
    open func collectionView(_ collectionView: UICollectionView,
                             didSelectItemAt indexPath: IndexPath,
                             containing facet: String,
                             with count: Int,
                             is refined: Bool) {
    }
}
