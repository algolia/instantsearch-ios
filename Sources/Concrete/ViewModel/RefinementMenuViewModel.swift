//
//  RefinementMenuViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation
import InstantSearchCore

public class RefinementMenuViewModel: RefinementMenuViewModelDelegate, SearchableViewModel {
    
    // MARK: - Properties
    
    var attribute: String {
        get {
            return view.attribute
        }
    }
    
    var refinedFirst: Bool {
        get {
            return view.refinedFirst
        }
    }
    
    var isDisjunctive: Bool {
        get {
            switch view.operator {
                case "or", "OR", "|", "||": return true
                case "and", "AND", "&", "&&": return false
            default: fatalError("operator of RefinementMenu cannot be interpreted. Please chose one of: 'or', 'and'")
            }
        }
    }
    
    var limit: Int {
        get {
            return view.limit
        }
    }
    
    var transformRefinementList: TransformRefinementList {
        get {
            return TransformRefinementList(named: view.sortBy.lowercased())
        }
    }
    
    var facetResults: [FacetValue] = []
    
    // MARK: - SearchableViewModel
    
    public var searcher: Searcher! {
        didSet {
            guard var facets = searcher.params.facets else {
                searcher.params.facets = [attribute]
                if searcher.results != nil { // if searching is ongoing
                    searcher.search() // Need to search again since don't have the facets
                }
                return
            }
            
            guard facets.contains(attribute) else {
                facets += [attribute]
                if searcher.results != nil { // if searching is ongoing
                    searcher.search() // Need to search since don't have the facets
                }
                return
            }
            
            // If facet variable has been set beforehand, then we fill
            // the refinement List with the facets that are already fetched from Algolia
            
            if let results = searcher.results, searcher.hits.count > 0 {
                facetResults = getRefinementList(facetCounts: results.facets(name: attribute), andFacetName: attribute, transformRefinementList: transformRefinementList, areRefinedValuesFirst: refinedFirst)
                
                view.reloadRefinements()
            }
        }
    }
    
    // MARK: - RefinementMenuViewModelDelegate
    
    weak public var view: RefinementMenuViewDelegate!
    
    public func numberOfRows(in section: Int) -> Int {
        return min(facetResults.count, limit)
    }
    
    public func facetForRow(at indexPath: IndexPath) -> FacetValue {
        return facetResults[indexPath.row]
    }
    
    public func isRefined(at indexPath: IndexPath) -> Bool {
        return searcher.params.hasFacetRefinement(name: attribute, value: facetResults[indexPath.item].value)
    }
    
    public func didSelectRow(at indexPath: IndexPath) {
        searcher.params.setFacet(withName: attribute, disjunctive: isDisjunctive)
        searcher.params.toggleFacetRefinement(name: attribute, value: facetResults[indexPath.item].value)
        searcher.search()
    }
}

extension RefinementMenuViewModel: ResultingDelegate {
    public func on(results: SearchResults?, error: Error?, userInfo: [String : Any]) {
        // TODO: Fix that cause for some reason, can't find the facet refinement.
        //,searcher.params.hasFacetRefinements(name: facet)
        // else { return }
        
        facetResults = getRefinementList(facetCounts: results?.facets(name: attribute), andFacetName: attribute, transformRefinementList: transformRefinementList, areRefinedValuesFirst: refinedFirst)
        view.reloadRefinements()
    }
}

extension RefinementMenuViewModel: ResettableDelegate {
    public func onReset() {
        view.reloadRefinements()
    }
}
