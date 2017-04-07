//
//  InstantSearchBinder.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

let clearAllFiltersNotification = Notification.Name(rawValue: "clearAllFiltersNotification")

/// The Presenter and Binder
@objc public class InstantSearchBinder : NSObject, SearcherDelegate {
    
    // MARK: - Properties
    
    // All widgets, including the specific ones such as refinementControlWidget
    // Note: Wish we could do a Set, but Swift doesn't support Set<GenericProtocol> for now.
    private var algoliaWidgets: [ResultingDelegate] = []
    private var algoliaInputWidgets: [RefinableDelegate] = []
    private var algoliaInputWidgetMap: [String: [RefinableDelegate]] = [:]
    
    public var searcher: Searcher
    
    // MARK: - Init
    
    @objc public init(searcher: Searcher, view: UIView? = nil) {
        self.searcher = searcher
        super.init()
        self.searcher.delegate = self
        
        // TODO: should we use nil for queue (OperationQueue) synchronous or not? Check..
        NotificationCenter.default.addObserver(self, selector: #selector(onReset(notification:)), name: clearAllFiltersNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRefinementNotification(notification:)), name: Searcher.RefinementChangeNotification, object: nil)
        
        if let view = view {
            addAllWidgets(in: view)
        }
        
        searcher.search()
    }
    
    // MARK: Add widget methods
    
    @objc public func addAllWidgets(in view: UIView) {
        addSubviewsOf(view: view)
    }
    
    // Recursively iterate the sub views.
    private func addSubviewsOf(view: UIView){
        
        // Get the subviews of the view
        let subviews = view.subviews
        
        // Return if there are no subviews
        if subviews.count == 0 {
            return
        }
        
        for subView in subviews as [UIView] {
            
            if let algoliaWidget = subView as? AlgoliaView {
                add(widget: algoliaWidget)
            }
            
            if let algoliaInputWidget = subView as? RefinableDelegate {
                addRefinementControl(widget: algoliaInputWidget)
            }
            
            // List the subviews of subview
            addSubviewsOf(view: subView)
        }
    }
    
    @objc public func add(widget: AlgoliaView) {
        guard !algoliaWidgets.contains(where: { $0 === widget } ) else { return }
        
        if let hitWidget = widget as? HitsViewDelegate {
            
            let hitsViewModel = Builder.build(hitView: hitWidget, with: searcher)
            algoliaWidgets.append(hitsViewModel)
        }
    }
    
    @objc public func addRefinementControl(widget: RefinableDelegate) {
        guard !algoliaInputWidgets.contains(where: { $0 === widget } ) else { return }
        
        // widget.searcher = searcher
        // algoliaWidgets.append(widget)
        algoliaInputWidgets.append(widget)
        
        let attributeName = widget.getAttributeName()
        
        if algoliaInputWidgetMap[attributeName] == nil {
            algoliaInputWidgetMap[attributeName] = []
        }
        
        algoliaInputWidgetMap[attributeName]!.append(widget)
    }
    
    // MARK: - Notification Observers
    
    func onReset(notification: Notification) {
        for algoliaWidget in algoliaWidgets {
            (algoliaWidget as? ResettableDelegate)?.onReset()
        }
    }
    
    func onRefinementNotification(notification: Notification) {
        let numericRefinementMap =  notification.userInfo?[Searcher.userInfoNumericRefinementChangeKey] as? [String: [NumericRefinement]]
        let facetRefinementMap =  notification.userInfo?[Searcher.userInfoFacetRefinementChangeKey] as? [String: [FacetRefinement]]
        
        callGeneralRefinementChanges(numericRefinementMap: numericRefinementMap, facetRefinementMap: facetRefinementMap)
        callSpecificNumericChanges(numericRefinementMap: numericRefinementMap)
        callSpecificFacetChanges(facetRefinementMap: facetRefinementMap)
    }
    
    
    // MARK: - SearcherDelegate
    
    public func searcher(_ searcher: Searcher, didReceive results: SearchResults?, error: Error?, userInfo: [String : Any]) {
        for algoliaWidget in algoliaWidgets {
            (algoliaWidget as? ResultingDelegate)?.on(results: results, error: error, userInfo: userInfo)
        }
    }
    
    // MARK: - Helper methods
    
    private func callGeneralRefinementChanges(numericRefinementMap:[String: [NumericRefinement]]?, facetRefinementMap: [String: [FacetRefinement]]?) {
        for refinementControlWidget in algoliaInputWidgets {
            refinementControlWidget.onRefinementChange?(numericMap: numericRefinementMap)
            refinementControlWidget.onRefinementChange?(facetMap: facetRefinementMap)
        }
    }
    
    private func callSpecificNumericChanges(numericRefinementMap:[String: [NumericRefinement]]?) {
        if let numericRefinementMap = numericRefinementMap {
            for (refinementName, numericRefinement) in numericRefinementMap {
                if let widgets = algoliaInputWidgetMap[refinementName] {
                    for widget in widgets {
                        widget.onRefinementChange?(numerics: numericRefinement)
                    }
                }
            }
        }
    }
    
    private func callSpecificFacetChanges(facetRefinementMap:[String: [FacetRefinement]]?) {
        if let facetRefinementMap = facetRefinementMap {
            for (refinementName, facetRefinement) in facetRefinementMap {
                if let widgets = algoliaInputWidgetMap[refinementName] {
                    for widget in widgets {
                        widget.onRefinementChange?(facets: facetRefinement)
                    }
                }
            }
        }
    }
    
    public func searchInPresenter(searchText: String) {
        searcher.params.query = searchText
        searcher.search()
    }
    
    // TODO: Move that away to RefinementList component
    func toggleFacetRefinement(name: String, value: String) {
        searcher.params.toggleFacetRefinement(name: name, value: value)
        searcher.search()
    }
}

extension InstantSearchBinder: UISearchResultsUpdating {
    
    @objc public func add(searchController: UISearchController) {
        searchController.searchResultsUpdater = self
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        searchInPresenter(searchText: searchText)
    }
}

extension InstantSearchBinder: UISearchBarDelegate {
    @objc public func add(searchBar: UISearchBar) {
        searchBar.delegate = self
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInPresenter(searchText: searchText)
    }
}
