//
//  FacetControlViewModel.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation
import InstantSearchCore

/// ViewModel - View: FacetControlViewModelDelegate.
///
/// ViewModel - Searcher: SearchableViewModel, RefinableDelegate, ResettableDelegate.
@objcMembers public class FacetControlViewModel: NSObject, FacetControlViewModelDelegate, SearchableIndexViewModel {
    
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
    
    private var _inclusive: Bool?

    public var inclusive: Bool {
        set {
            _inclusive = newValue
        } get {
            return _inclusive ?? view?.inclusive ?? Constants.Defaults.inclusive
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
    
    // MARK: - SearchableViewModel
    
    var searcher: Searcher!
    
    public func configure(with searcher: Searcher) {
        self.searcher = searcher
        
        guard !attribute.isEmpty else {
            fatalError("you must assign a value to the attribute of a Facet Control before adding it to InstantSearch")
        }
        
        // TODO: A specific facet can have many refinements. But in the case
        // of facetControl (contrary to facetMenu), will we only have at the maximum one value?
        // Right now, taknig the first refinement in getFacetRefinement but can do better...
        // since now we ll have bugs
        if self.searcher.params.hasFacetRefinements(name: self.attribute) {
            view?.set(value: self.searcher.params.getFacetRefinement(name: attribute)!.value)
        }

        view?.configureView()
    }
    
    // MARK: - NumericControlViewModelDelegate
    
    public weak var view: FacetControlViewDelegate?
    
    override init() { }
    
    public init(view: FacetControlViewDelegate) {
        self.view = view
    }
    
    public func addFacet(value: String, doSearch: Bool) {
        guard !self.searcher.params.hasFacetRefinement(name: self.attribute, value: value) else { return }
        self.searcher.params.addFacetRefinement(name: self.attribute, value: value, inclusive: inclusive)
        if doSearch {
            self.searcher.search()
        }
    }
    
    public func updateFacet(oldValue: String, newValue: String, doSearch: Bool) {
        self.searcher.params.updateFacetRefinement(attribute: self.attribute,
                                                   oldValue: oldValue,
                                                   newValue: newValue,
                                                   inclusive: inclusive)
        
        if doSearch {
            self.searcher.search()
        }
    }
    
    public func removeFacet(value: String) {
        self.searcher.params.removeFacetRefinement(name: self.attribute, value: value)
        self.searcher.search()
    }
}

// MARK: - RefinableDelegate

extension FacetControlViewModel: RefinableDelegate {
    
    public func onRefinementChange(facets: [FacetRefinement]) {
        for facet in facets where facet.name == self.attribute && facet.inclusive == inclusive {
            view?.set(value: facet.value)
            return
        }
        
        // Could not find it anymore, so need to notify!
        view?.set(value: "")
    }
    
}

// MARK: - ResettableDelegate

// TODO: These needs to be tested, improved, and moved to InstantSearch Core.
extension SearchParameters {
  
    /// Gets only the first one it finds
    public func getFacetRefinement(name facetName: String) -> FacetRefinement? {
        return facetRefinements[facetName]?.first
    }
  
    /// Gets only the first one it finds
    public func getNumericRefinement(name filterName: String,
                                     operator: NumericRefinement.Operator,
                                     inclusive: Bool = true) -> NumericRefinement? {
        return numericRefinements[filterName]?.first(where: { $0.op == `operator` && $0.inclusive == inclusive})
    }
    
    public func updateFacetRefinement(attribute: String, oldValue: String, newValue: String, inclusive: Bool = true) {
        guard !hasFacetRefinement(name: attribute, value: newValue) else { return }
        removeFacetRefinement(name: attribute, value: oldValue)
        addFacetRefinement(name: attribute, value: newValue, inclusive: inclusive)
    }
}
