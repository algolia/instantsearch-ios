//
//  HitsCollectionViewController.swift
//  InstantSearch
//
//  Created by Guy Daher on 14/04/2017.
//
//

import Foundation
import UIKit

/// Base class that is meant to be inherited from a ViewController.
/// This class gives you the boilerplate needed to have a hits view linked to InstantSearch.
/// It imlpements the collectionView dataSource and delegate protocols, 
/// and exposes the methods from `HitsCollectionViewDataSource` and `HitsCollectionViewDelegate`.
/// + Note: You **have** to implement the `collectionView(_:cellForItemAt:containing:)` method in your class 
/// to specify the layout of your hit cells, or else you will get a fatalError.
@objc open class HitsCollectionViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate, HitsCollectionViewDataSource, HitsCollectionViewDelegate {
    
    var hitsController: HitsController!
    
    /// Reference to the Hits Collection Widget
    public var hitsCollectionView: HitsCollectionWidget! {
        didSet {
            hitsController = HitsController(collection: hitsCollectionView)
            hitsCollectionView.dataSource = self
            hitsCollectionView.delegate = self
            hitsController.collectionDataSource = self
            hitsController.collectionDelegate = self
        }
    }
    
    // Forward the 3 important dataSource and delegate methods to the HitsCollectionWidget
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hitsController.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.hitsController.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return self.hitsController.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.hitsController.numberOfSections(in: collectionView)
    }
    
    // The follow methods are to be implemented by the class extending HitsCollectionViewController
    
    /// DataSource method called to specify the layout of a hit cell.
    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath,
                             containing hit: [String : Any]) -> UICollectionViewCell {
        fatalError("Must Override collectionView(_:cellForItemAt:containing:)")
    }
    
    /// Delegate method called when a hit cell is selected.
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, containing hit: [String : Any]) {
        
    }
}
