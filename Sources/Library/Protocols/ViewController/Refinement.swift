//
//  Refinement.swift
//  InstantSearch
//
//  Created by Guy Daher on 25/04/2017.
//
//

import Foundation
import UIKit

/// DataSource for a Table Refinement Menu Widget.
@objc public protocol RefinementTableViewDataSource: class {
    
    /// DataSource method called to specify the layout of a facet cell.
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath,
                   containing facet: String,
                   with count: Int,
                   is refined: Bool) -> UITableViewCell
    
    /// DataSource method called to specify the no result view when 0 results are returned from Algolia.
    @objc optional func viewForNoResults(in tableView: UITableView) -> UIView
}

/// Delegate for a Table Refinement Menu Widget.
@objc public protocol RefinementTableViewDelegate: class {
    
    /// Delegate method called when a facet cell is selected.
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath,
                   containing facet: String,
                   with count: Int,
                   is refined: Bool)
}

/// DataSource for a Collection Refinement Menu Widget.
@objc public protocol RefinementCollectionViewDataSource: class {
    
    /// DataSource method called to specify the layout of a facet cell.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath,
                        containing facet: String,
                        with count: Int,
                        is refined: Bool) -> UICollectionViewCell
    
    /// DataSource method called to specify the view when there are no results returned from Algolia,
    /// or if an error occured when doing the request.
    @objc optional func viewForNoResults(in collectionView: UICollectionView) -> UIView
}

/// Delegate for a Collection Refinement Menu Widget.
@objc public protocol RefinementCollectionViewDelegate: class {
    
    /// Delegate method called when a facet cell is selected.
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath,
                        containing facet: String,
                        with count: Int,
                        is refined: Bool)
}
