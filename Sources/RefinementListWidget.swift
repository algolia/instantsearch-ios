//
//  RefinementList.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

@IBDesignable
@objc public class RefinementListWidget: UITableView, ResultingDelegate, AlgoliaFacetDataSource2, AlgoliaFacetDelegate, UITableViewDataSource, UITableViewDelegate, SearchableViewModel, AlgoliaView, ResettableDelegate {
    public var searcher: Searcher! {
        didSet {
            delegate = self
            dataSource = self
            
            guard var facets = searcher.params.facets else {
                searcher.params.facets = [facet]
                if searcher.results != nil { // if searching is ongoing
                    searcher.search() // Need to search again since don't have the facets
                }
                return
            }
            
            guard facets.contains(facet) else {
                facets += [facet]
                if searcher.results != nil { // if searching is ongoing
                    searcher.search() // Need to search since don't have the facets
                }
                return
            }
            
            // If facet variable has been set beforehand, then we fill
            // the refinement List with the facets that are already fetched from Algolia
            
            if let results = searcher.results, searcher.hits.count > 0 {
                facetResults = searcher.getRefinementList(facetCounts: results.facets(name: facet), andFacetName: facet, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
                
                reloadData()
            }
        }
    }
    
    @IBInspectable var facet: String = ""
    @IBInspectable var areRefinedValuesFirst: Bool = true
    @IBInspectable var isDisjunctive: Bool = true
    
    var transformRefinementList = TransformRefinementList.countDesc
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'transformRefinementList' instead.")
    @IBInspectable var sorting: String? {
        willSet {
            transformRefinementList = TransformRefinementList(named: newValue?.lowercased() ?? "")
        }
    }
    
    var facetResults: [FacetValue] = []
    @objc public weak var facetDataSource: FacetDataSource?
    
    public func on(results: SearchResults?, error: Error?, userInfo: [String : Any]) {
            // TODO: Fix that cause for some reason, can't find the facet refinement.
            //,searcher.params.hasFacetRefinements(name: facet)
            // else { return }
        
        facetResults = searcher.getRefinementList(facetCounts: results?.facets(name: facet), andFacetName: facet, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        reloadData()
    }
    
    public func onReset() {
        reloadData()
    }
    
    public func numberOfRows(in section: Int) -> Int {
        return searcher.results?.facets(name: facet)?.count ?? 0
    }
    
    public func facetForRow(at indexPath: IndexPath) -> FacetValue {
        return facetResults[indexPath.row]
    }
    
    public func isRefined(at indexPath: IndexPath) -> Bool {
        return searcher.params.hasFacetRefinement(name: facet, value: facetResults[indexPath.item].value)
    }
    
    public func didSelectRow(at indexPath: IndexPath) {
        searcher.params.setFacet(withName: facet, disjunctive: isDisjunctive)
        searcher.params.toggleFacetRefinement(name: facet, value: facetResults[indexPath.item].value)
        searcher.search()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let facetValue = facetForRow(at: indexPath)
        let isRefined = self.isRefined(at: indexPath)
        return facetDataSource?.cellFor(facetValue: facetValue, isRefined: isRefined, at: indexPath) ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        didSelectRow(at: indexPath)
    }
}

@objc public protocol AlgoliaFacetDataSource2 {
    func numberOfRows(in section: Int) -> Int
    func facetForRow(at indexPath: IndexPath) -> FacetValue
    func isRefined(at indexPath: IndexPath) -> Bool
}

@objc public protocol AlgoliaFacetDelegate {
    func didSelectRow(at indexPath: IndexPath)
}

@objc public protocol FacetDataSource: class {
    func cellFor(facetValue: FacetValue, isRefined: Bool, at indexPath: IndexPath) -> UITableViewCell
}
