//
//  Hits.swift
//  InstantSearch
//
//  Created by Guy Daher on 25/04/2017.
//
//

import Foundation
import UIKit

/// DataSource for a Table Hits Widget.
@objc public protocol HitsTableViewDataSource: class {
    
    /// DataSource method called to specify the layout of a hit cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String: Any]) -> UITableViewCell
    
    /// DataSource method called to specify the no result view when 0 results are returned from Algolia.
    @objc optional func viewForNoResults(in tableView: UITableView) -> UIView
}

/// Delegate for a Table Hits Widget.
@objc public protocol HitsTableViewDelegate: class {
    
    /// Delegate method called when a hit cell is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String: Any])
}

/// DataSource for a Collection Hits Widget.
@objc public protocol HitsCollectionViewDataSource: class {
    
    /// DataSource method called to specify the layout of a hit cell.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath,
                        containing hit: [String: Any]) -> UICollectionViewCell
    
    /// DataSource method called to specify the view when there are no results returned from Algolia,
    /// or if an error occured when doing the request.
    @objc optional func viewForNoResults(in collectionView: UICollectionView) -> UIView
}

/// Delegate for a Collection Hits Widget.
@objc public protocol HitsCollectionViewDelegate: class {
    
    /// Delegate method called when a hit cell is selected.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, containing hit: [String: Any])
}
