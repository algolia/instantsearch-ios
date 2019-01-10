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
@objcMembers public class RefinementMenuViewModel: NSObject, RefinementMenuViewModelDelegate, SearchableIndexViewModel {
    
    // MARK: - Properties
    private var _searcherId: SearcherId?

    public var searcherId: SearcherId {
        set {
            _searcherId = newValue
        } get {
            if let strongSearcherId = _searcherId { return strongSearcherId}

            if let view = view {
                return SearcherId(index: view.index, variant: view.variant)
            } else {
                print("ERROR - ViewModel not associated to any searcherId or View, so it cannot operate")
                return SearcherId(index: "")
            }
        }
    }
    
    private var _refinedFirst: Bool?

    public var refinedFirst: Bool {
        set {
            _refinedFirst = newValue
        } get {
            return _refinedFirst ?? view?.refinedFirst ?? Constants.Defaults.refinedFirst
        }
    }

    private var _attribute: String?

    public var attribute: String {
        set {
            _attribute = newValue
        } get {
            return _attribute ?? view?.attribute ?? Constants.Defaults.attribute
        }
    }

    private var _isDisjunctive: Bool?

    var isDisjunctive: Bool {
        set {
            _isDisjunctive = newValue
        } get {
            if let strongIsDisjunctive = _isDisjunctive { return strongIsDisjunctive}
            switch view?.operator ?? Constants.Defaults.operatorRefinement {
            case "or", "OR", "|", "||": return true
            case "and", "AND", "&", "&&": return false
            default: fatalError("operator of RefinementMenu cannot be interpreted. Please chose one of: 'or', 'and'")
            }
        }
    }

    private var _areMultipleSelectionsAllowed: Bool?

    var areMultipleSelectionsAllowed: Bool {
        set {
            _areMultipleSelectionsAllowed = newValue
        } get {
            return _areMultipleSelectionsAllowed
                ?? view?.areMultipleSelectionsAllowed
                ?? Constants.Defaults.areMultipleSelectionsAllowed
        }
    }

    private var _limit: Int?

    public var limit: Int {
        set {
            _limit = newValue
        } get {
            return _limit ?? view?.limit ?? Constants.Defaults.limit
        }
    }
    
    var transformRefinementList: TransformRefinementList {
        if let view = view {
            return TransformRefinementList(named: view.sortBy.lowercased())
        } else {
            return TransformRefinementList(named: Constants.Defaults.sortBy.lowercased())
        }
    }
    
    // TODO" The state for this should be on IS Core, not in the VM.
    public var facetResults: [FacetValue] = []
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    public func configure(with searcher: Searcher) {
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
        
        if let results = searcher.results, let facetCounts = results.facets(name: attribute) {
            facetResults = getRefinementList(params: searcher.params,
                                             facetCounts: facetCounts,
                                             andFacetName: attribute,
                                             transformRefinementList: transformRefinementList,
                                             areRefinedValuesFirst: refinedFirst)
            
            view?.reloadRefinements()
        }
    }
    
    // MARK: - RefinementMenuViewModelDelegate
    
    public weak var view: RefinementMenuViewDelegate?
    
    override init() { }
    
    public init(view: RefinementMenuViewDelegate) {
        self.view = view
    }
    
    public func numberOfRows() -> Int {
        return min(facetResults.count, limit)
    }
    
    public func facetForRow(at indexPath: IndexPath) -> FacetValue {
        return facetResults[indexPath.row]
    }
    
    public func isRefined(at indexPath: IndexPath) -> Bool {
        return searcher.params.hasFacetRefinement(name: attribute, value: facetResults[indexPath.item].value)
    }
    
    /// This simulated selecting a facet
    /// it will tggle the facet refinement, deselect the row and then execute a search
    public func didSelectRow(at indexPath: IndexPath) {

        if isDisjunctive {
          searcher.params.setFacet(withName: attribute, disjunctive: true)
          searcher.params.toggleFacetRefinement(name: attribute, value: facetResults[indexPath.item].value)
        } else if !isDisjunctive && areMultipleSelectionsAllowed {
          searcher.params.setFacet(withName: attribute, disjunctive: false)
          searcher.params.toggleFacetRefinement(name: attribute, value: facetResults[indexPath.item].value)
        } else {
          // when conjunctive and one single value can be selected,
          // we need to keep the other values visible, so we still do a disjunctive facet
          searcher.params.setFacet(withName: attribute, disjunctive: true)
          let value = facetResults[indexPath.item].value
          
          if searcher.params.hasFacetRefinement(name: attribute, value: value) { // deselect if already selected
            searcher.params.clearFacetRefinements(name: attribute)
          } else { // select new one only.
            searcher.params.clearFacetRefinements(name: attribute)
            searcher.params.addFacetRefinement(name: attribute, value: value)
          }
          
        }
        view?.deselectRow(at: indexPath)
        searcher.search()
    }
}

extension RefinementMenuViewModel: ResultingDelegate {
    public func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {

        defer {
            view?.reloadRefinements()
        }

        guard let results = results else {
            print(error ?? "")
            return
        }
        
        guard let facetCounts = results.facets(name: attribute) else {
            print("No facet counts found for attribute: \(attribute)")
            facetResults = []

            return
        }
        
        facetResults = getRefinementList(params: searcher.params,
                                         facetCounts: facetCounts,
                                         andFacetName: attribute,
                                         transformRefinementList: transformRefinementList,
                                         areRefinedValuesFirst: refinedFirst)
    }
}

extension RefinementMenuViewModel: ResettableDelegate {
    func onReset() {
        view?.reloadRefinements()
    }
}
