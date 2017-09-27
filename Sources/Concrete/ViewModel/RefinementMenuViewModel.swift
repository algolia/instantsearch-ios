//
//  RefinementMenuViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation
import InstantSearchCore

/// ViewModel - View: RefinementMenuViewModelDelegate.
///
/// ViewModel - Searcher: SearchableViewModel, ResultingDelegate, ResettableDelegate.
internal class RefinementMenuViewModel: RefinementMenuViewModelDelegate, SearchableViewModel {
    
    // MARK: - Properties
    
    var attribute: String {
        return view.attribute
    }
    
    var refinedFirst: Bool {
        return view.refinedFirst
    }
    
    var isDisjunctive: Bool {
        switch view.operator {
        case "or", "OR", "|", "||": return true
        case "and", "AND", "&", "&&": return false
        default: fatalError("operator of RefinementMenu cannot be interpreted. Please chose one of: 'or', 'and'")
        }
    }
    
    var limit: Int {
        return view.limit
    }
    
    var transformRefinementList: TransformRefinementList {
        return TransformRefinementList(named: view.sortBy.lowercased())
    }
    
    var facetResults: [FacetValue] = []
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        guard !attribute.isEmpty else {
            fatalError("you must assign a value to the attribute of a refinement before adding it to InstantSearch")
        }
        
        // check if need to search again, if we didn't search with the facet added
        
        guard let facets = searcher.params.facets else {
            searcher.params.facets = [attribute]
            
            return
        }
        
        guard facets.contains(attribute) else {
            searcher.params.facets! += [attribute]
            
            return
        }
        
        // If facet variable has been set beforehand, then we fill
        // the refinement List with the facets that are already fetched from Algolia
        
        if let results = searcher.results, searcher.hits.isEmpty, let facetCounts = results.facets(name: attribute) {
            facetResults = getRefinementList(params: searcher.params,
                                             facetCounts: facetCounts,
                                             andFacetName: attribute,
                                             transformRefinementList: transformRefinementList,
                                             areRefinedValuesFirst: refinedFirst)
            
            view.reloadRefinements()
        }
    }
    
    // MARK: - RefinementMenuViewModelDelegate
    
    weak var view: RefinementMenuViewDelegate!
    
    func numberOfRows() -> Int {
        return min(facetResults.count, limit)
    }
    
    func facetForRow(at indexPath: IndexPath) -> FacetValue {
        return facetResults[indexPath.row]
    }
    
    func isRefined(at indexPath: IndexPath) -> Bool {
        return searcher.params.hasFacetRefinement(name: attribute, value: facetResults[indexPath.item].value)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        
        searcher.params.setFacet(withName: attribute, disjunctive: isDisjunctive)
        searcher.params.toggleFacetRefinement(name: attribute, value: facetResults[indexPath.item].value)
        view.deselectRow(at: indexPath)
        searcher.search()
    }
}

extension RefinementMenuViewModel: ResultingDelegate {
    func on(results: SearchResults?, error: Error?, userInfo: [String : Any]) {
        
        guard let results = results else {
            print(error ?? "")
            return
        }
        
        guard let facetCounts = results.facets(name: attribute) else {
            print("No facet counts found for attribute: \(attribute)")
            return
        }
        
        facetResults = getRefinementList(params: searcher.params,
                                         facetCounts: facetCounts,
                                         andFacetName: attribute,
                                         transformRefinementList: transformRefinementList,
                                         areRefinedValuesFirst: refinedFirst)
        view.reloadRefinements()
    }
}

extension RefinementMenuViewModel: ResettableDelegate {
    func onReset() {
        view.reloadRefinements()
    }
}
