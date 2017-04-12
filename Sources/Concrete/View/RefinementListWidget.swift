//
//  RefinementList.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
@objc public class RefinementListWidget: UITableView, UITableViewDataSource, UITableViewDelegate, RefinementMenuViewDelegate, AlgoliaView {
    
    public var viewModel: RefinementMenuViewModelDelegate!
    
    public func reloadRefinements() {
        reloadData()
    }
    
    @IBInspectable public var facet: String = ""
    @IBInspectable public var areRefinedValuesFirst: Bool = true
    @IBInspectable public var isDisjunctive: Bool = true

    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'transformRefinementList' instead.")
    @IBInspectable public var sorting: String = "countDesc"
    
    @objc public weak var facetDataSource: FacetDataSource? {
        didSet {
            dataSource = self
            delegate = self
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let facetValue = viewModel.facetForRow(at: indexPath)
        let isRefined = viewModel.isRefined(at: indexPath)
        return facetDataSource?.cellFor(facet: facetValue.value, count: facetValue.count, isRefined: isRefined, at: indexPath) ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath)
    }
}

@objc public protocol FacetDataSource: class {
    func cellFor(facet: String, count: Int, isRefined: Bool, at indexPath: IndexPath) -> UITableViewCell
}
