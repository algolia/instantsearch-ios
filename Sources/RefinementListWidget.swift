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
class RefinementListWidget: UITableView, AlgoliaWidget, AlgoliaFacetDataSource2, AlgoliaFacetDelegate, UITableViewDataSource, UITableViewDelegate {
    private var searcher: Searcher!
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
    weak var facetDataSource: FacetDataSource?
    
    func initWith(searcher: Searcher) {
        self.searcher = searcher
        delegate = self
        dataSource = self
        // TODO: Make the countDesc and refinedFirst customisable ofc. 
        if let results = searcher.results, let hits = searcher.hits, hits.count > 0 {
            facetResults = searcher.getRefinementList(facetCounts: results.facets(name: facet), andFacetName: facet, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
            
            reloadData()
        }
    }
    
    func on(results: SearchResults?, error: Error?, userInfo: [String : Any]) {
            // TODO: Fix that cause for some reason, can't find the facet refinement.
            //,searcher.params.hasFacetRefinements(name: facet)
            // else { return }
        
        facetResults = searcher.getRefinementList(facetCounts: results?.facets(name: facet), andFacetName: facet, transformRefinementList: transformRefinementList, areRefinedValuesFirst: areRefinedValuesFirst)
        reloadData()
    }
    
    func onReset() {
        
    }
    
    func numberOfRows(in section: Int) -> Int {
        return searcher.results?.facets(name: facet)?.count ?? 0
    }
    
    func facetForRow(at indexPath: IndexPath) -> FacetValue {
        return facetResults[indexPath.row]
    }
    
    func isRefined(at indexPath: IndexPath) -> Bool {
        return searcher.params.hasFacetRefinement(name: facet, value: facetResults[indexPath.item].value)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        searcher.params.setFacet(withName: facet, disjunctive: isDisjunctive)
        searcher.params.toggleFacetRefinement(name: facet, value: facetResults[indexPath.item].value)
        searcher.search()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let facetValue = facetForRow(at: indexPath)
        let isRefined = self.isRefined(at: indexPath)
        return facetDataSource?.cellFor(facetValue: facetValue, isRefined: isRefined, at: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        didSelectRow(at: indexPath)
    }
}

protocol AlgoliaFacetDataSource2 {
    func numberOfRows(in section: Int) -> Int
    func facetForRow(at indexPath: IndexPath) -> FacetValue
    func isRefined(at indexPath: IndexPath) -> Bool
}

protocol AlgoliaFacetDelegate {
    func didSelectRow(at indexPath: IndexPath)
}

protocol FacetDataSource: class {
    func cellFor(facetValue: FacetValue, isRefined: Bool, at indexPath: IndexPath) -> UITableViewCell
}
