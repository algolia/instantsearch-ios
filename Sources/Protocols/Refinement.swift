//
//  Refinement.swift
//  InstantSearch
//
//  Created by Guy Daher on 25/04/2017.
//
//

import Foundation
import UIKit

@objc public protocol RefinementTableViewDataSource: class {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) -> UITableViewCell
}

@objc public protocol RefinementTableViewDelegate: class {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool)
}

@objc public protocol RefinementCollectionViewDataSource: class {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, containing facet: String, with count: Int, is refined: Bool) -> UICollectionViewCell
}

@objc public protocol RefinementCollectionViewDelegate: class {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, containing hit: [String: Any])
}
