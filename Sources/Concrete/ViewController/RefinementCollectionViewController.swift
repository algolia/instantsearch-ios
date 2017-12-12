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
    
    var refinementControllers: [RefinementController] = []
    
    /// Reference to the Refinement Collection Widget
    public var refinementCollectionView: RefinementCollectionWidget! {
        didSet {
            refinementCollectionViews = [refinementCollectionView]
        }
    }
    
    /// Reference to the Refinement Collection Widgets if there are more than one.
    public var refinementCollectionViews: [RefinementCollectionWidget] = [] {
        didSet {
            for refinementCollectionView in refinementCollectionViews {
                let refinementController = RefinementController(collection: refinementCollectionView)
                refinementControllers.append(refinementController)
                refinementCollectionView.dataSource = self
                refinementCollectionView.delegate = self
                refinementController.collectionDataSource = self
                refinementController.collectionDelegate = self
            }
        }
    }
    
    // Forward the 3 important dataSource and delegate methods to the HitsCollectionWidget
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? RefinementCollectionWidget,
            let index = self.refinementCollectionViews.index(of: collectionView) else { return 0 }
        
        return self.refinementControllers[index].collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionView = collectionView as? RefinementCollectionWidget,
            let index = self.refinementCollectionViews.index(of: collectionView) else { return UICollectionViewCell() }
        
        return self.refinementControllers[index].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collectionView = collectionView as? RefinementCollectionWidget,
            let index = self.refinementCollectionViews.index(of: collectionView) else { return }
        self.refinementControllers[index].collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let collectionView = collectionView as? RefinementCollectionWidget,
            let index = self.refinementCollectionViews.index(of: collectionView) else { return 0 }
        
        return self.refinementControllers[index].numberOfSections(in: collectionView)
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
