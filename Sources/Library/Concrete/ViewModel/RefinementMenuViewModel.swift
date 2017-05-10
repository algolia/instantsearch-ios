//
//  RefinementMenuViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation
import InstantSearchCore

internal class RefinementMenuViewModel: RefinementMenuViewModelDelegate, SearchableViewModel {
    
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
    
    // TODO: Should we move this to the InstantSearch Core level?
    var facetResults: [FacetValue] = []
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        guard !attribute.isEmpty else {
            fatalError("you must assign a value to the attribute of a refinement before adding it to InstantSearch")
        }
        
        // check if need to search again if we didn't searh with the facet added
        
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
        
        // TODO: Bug of storing state at this level instead of Searcher level.
        // Think if have 2 refinement menu widgets on same screen refereing 2 different viewmodels,
        // so the state of facetResults will not be shared between them. careful...
        if let results = searcher.results, searcher.hits.count > 0 {
            facetResults = getRefinementList(searcher: searcher, facetCounts: results.facets(name: attribute), andFacetName: attribute, transformRefinementList: transformRefinementList, areRefinedValuesFirst: refinedFirst)
            
            view.reloadRefinements()
        }
    }
    
    // MARK: - RefinementMenuViewModelDelegate
    
    weak var view: RefinementMenuViewDelegate!
    
    func numberOfRows(in section: Int) -> Int {
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
        guard let searcher = searcher else { return }
        // TODO: Fix that cause for some reason, can't find the facet refinement.
        //,searcher.params.hasFacetRefinements(name: facet)
        // else { return }
        
        facetResults = getRefinementList(searcher: searcher, facetCounts: results?.facets(name: attribute), andFacetName: attribute, transformRefinementList: transformRefinementList, areRefinedValuesFirst: refinedFirst)
        view.reloadRefinements()
    }
}

extension RefinementMenuViewModel: ResettableDelegate {
    func onReset() {
        view.reloadRefinements()
    }
}
