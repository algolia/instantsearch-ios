//
//  InstantSearch.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import AlgoliaSearch

// ------------------------------------------------------------------------------------------------------
// IMPLEMENTATION NOTES
// ------------------------------------------------------------------------------------------------------
//
// # Architecture of InstantSearch
//
// InstantSearch is inspired by both MVVM architecture.
//
// This is an overview of the architecture:
//
// ```
// View <--> ViewModel <--> Binder <--> Interactor/Model
// ```
//
// Widgets can mean two things, depending on how modular you want your components to be:
//
//
// 1. It can be the View
//
// ```
// WidgetV <--> WidgetVM <--> Binder <--> Searcher
// ```
//
// In this first case, we offer a better modular architecture where a WidgetVM can be reused
// for different kind of widgets, for example: a collectionView and tableView can share
// the same VM since the business logic is exactly the same, only the layout changes.
// In that case, the Widget is independent of InstantSearchCore and WidgetVM is independent of UIKit.
//
//
// 2. It can be the View and the ViewModel
//
// ```
// WidgetVVM <--> Binder <--> Searcher
// ```
//
// In this second case, we offer an easier way to create new widgets since the widget has access
// to the searcher and all of its method. The downside here is that we can't reuse the business logic
// through a VM. The upside is that it's easy for 3rd party devs to create their own widgets and plug into IS.
// In that case, the Widget is dependent on both InstantSearchCore and UIKit.
//
// We note that the View and the ViewModel depend on abstract delegates, which makes them reusable and testable.
//
// Finally, the Binder plays a role of exposing all possible search events, whether from the Searcher or other widgets,
// and making them available for ViewModels or Views so that they can tune in.
// In a way, it is like an observable that knows about all search events, and it will send the search events to
// the observers that decided to tune in. We decided to go with delegation to offer a clean safe interface.
//
// ------------------------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------
// InstantSearch NOTES
// ---------------------------------------------------------------------------------
// InstantSearch does mainly 3 things:
// 1. Scans the View to find Algolia Widgets
// 2. Knows about all search events, whether coming from the Searcher or other widgets
// 3. Binds Searcher - Widgets through delegation
//
// For the 3rd point, InstantSearch binds the following:
// - Searcher and WidgetV through a ViewModelFetcher that creates the appropriate WidgetVM
// - Searcher and WidgetVVM
// ---------------------------------------------------------------------------------

/// Binds the Searcher to the widgets through delegation.
@objc public class InstantSearch: NSObject, SearcherDelegate {

    /// The singleton instance.
    public static let reference = InstantSearch()

    // MARK: - Properties

    // All widgets, including the specific ones such as refinementControlWidget
    // Note: Wish we could do a Set, but Swift doesn't support Set<GenericProtocol> for now.
    private var resultingDelegates = WeakSet<ResultingDelegate>()
    private var resettableDelegates = WeakSet<ResettableDelegate>()
    private var refinableDelegates = WeakSet<RefinableDelegate>()
    private var refinableDelegateMap = [String: WeakSet<RefinableDelegate>]()

    public var searcher: Searcher!

    public var params: SearchParameters {
        return searcher.params
    }

    private lazy var viewModelFetcher: ViewModelFetcher = {
        return ViewModelFetcher()
    }()

    // MARK: - Init and Configure

    private override init() {
        super.init()
    }

    public convenience init(appID: String, apiKey: String, index: String) {
        self.init()
        self.configure(appID: appID, apiKey: apiKey, index: index)
    }

    public convenience init(searcher: Searcher) {
        self.init()
        configure(searcher: searcher)
    }

    @objc public func configure(appID: String, apiKey: String, index: String) {
        let client = Client(appID: appID, apiKey: apiKey)
        let index = client.index(withName: index)
        let searcher = Searcher(index: index)
        configure(searcher: searcher)
    }

    private func configure(searcher: Searcher) {
        self.searcher = searcher
        self.searcher.delegate = self

        // TODO: should we use nil sefor queue (OperationQueue) synchronous or not? Check..
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reset),
                                               name: clearAllFiltersNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onRefinementNotification(notification:)),
                                               name: Searcher.RefinementChangeNotification,
                                               object: nil)
    }

    // MARK: Add widget methods

    @objc public func addAllWidgets(in view: UIView, doSearch: Bool = true) {
        addWidgets(in: view)

        // After added all widgets, the widgets might have added
        // parameters to the searcher.params. So we need to trigger a new search
        if doSearch {
            self.searcher.search()
        }
    }

    // Recursively iterate the sub views.
    private func addWidgets(in view: UIView) {

        // Get the subviews of the view
        let subviews = view.subviews

        // Return if there are no subviews
        if subviews.isEmpty {
            return
        }

        for subView in subviews as [UIView] {

            if let algoliaWidget = subView as? AlgoliaWidget {
                add(widget: algoliaWidget, doSearch: false)
            }

            // List the subviews of subview
            addWidgets(in: subView)
        }
    }

    @objc public func add(widget: AlgoliaWidget) {

        if widget is RefinementMenuViewDelegate
            || widget is NumericControlViewDelegate
            || widget is FacetControlViewDelegate {
            add(widget: widget, doSearch: true)
        } else {
            add(widget: widget, doSearch: false)
        }

    }

    @objc public func add(widget: AlgoliaWidget, doSearch: Bool) {

        var widgetVM: Any?

        // -------------------------------------------------------------------------------------
        // Widgets that act only as Views (WidgetV)
        // We spin off a ViewModel associated to the particular View (WidgetVM)
        // (e.g: HitsTableWidget will lead to spin off HitsViewModel)
        // In that case, the ViewModel is the delegate to the events emitted by the Searcher
        // -------------------------------------------------------------------------------------
        widgetVM = viewModelFetcher.tryFetchWidgetVM(with: widget)

        // --------------------------------------------------------------------------------------
        // If the widget doesn't have a specific WidgetVM, that means that it is itself
        // acting both as a View and a ViewModel (WidgetVVM), so we assign it to the WidgetVM
        // in order to hook it up to search events
        // --------------------------------------------------------------------------------------
        widgetVM = widgetVM ?? widget

        // --------------------------------------------------------------------------------------
        // Hook the search events to the ViewModel. Reminder of the kinds of ViewModels:
        // - Pure VM created by the ViewModelFetcher
        // - A WidgetVVM.
        // --------------------------------------------------------------------------------------
        bind(searcher: searcher, to: widgetVM)

        // After a widget is added, we can decide to make a search. This is when
        // a widget modifies the state of the searcher.params
        if doSearch {
            searcher.search()
        }
    }

    private func bind(searcher: Searcher, to widgetVM: Any?) {
        if let searchableWidget = widgetVM as? SearchableViewModel {
            searchableWidget.configure(with: searcher)
        }

        if let resultingWidget = widgetVM as? ResultingDelegate {
            resultingDelegates.add(resultingWidget)
        }

        if let resettableWidget = widgetVM as? ResettableDelegate {
            resettableDelegates.add(resettableWidget)
        }

        if let refinableWidget = widgetVM as? RefinableDelegate {
            refinableDelegates.add(refinableWidget)

            let attributeName = refinableWidget.attribute

            if refinableDelegateMap[attributeName] == nil {
                refinableDelegateMap[attributeName] = WeakSet<RefinableDelegate>()
            }

            refinableDelegateMap[attributeName]!.add(refinableWidget)
        }
    }

    // MARK: - Notification Observers

    public func reset() {
        for algoliaWidget in resettableDelegates {
            algoliaWidget.onReset()
        }
    }

    func onRefinementNotification(notification: Notification) {
        let numericRefinementMap = notification.userInfo?[Searcher.userInfoNumericRefinementChangeKey] as? [String: [NumericRefinement]]
        let facetRefinementMap = notification.userInfo?[Searcher.userInfoFacetRefinementChangeKey] as? [String: [FacetRefinement]]

        callGeneralRefinementChanges(numericRefinementMap: numericRefinementMap, facetRefinementMap: facetRefinementMap)
        callSpecificNumericChanges(numericRefinementMap: numericRefinementMap)
        callSpecificFacetChanges(facetRefinementMap: facetRefinementMap)
    }

    // MARK: - SearcherDelegate

    public func searcher(_ searcher: Searcher, didReceive results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        for algoliaWidget in resultingDelegates {
            algoliaWidget.on(results: results, error: error, userInfo: userInfo)
        }
    }

    // MARK: - Helper methods

    private func callGeneralRefinementChanges(
        numericRefinementMap: [String: [NumericRefinement]]?,
        facetRefinementMap: [String: [FacetRefinement]]?) {
        for refinementControlWidget in refinableDelegates {
            refinementControlWidget.onRefinementChange?(numericMap: numericRefinementMap)
            refinementControlWidget.onRefinementChange?(facetMap: facetRefinementMap)
        }
    }

    private func callSpecificNumericChanges(numericRefinementMap: [String: [NumericRefinement]]?) {
        if let numericRefinementMap = numericRefinementMap {
            for (refinementName, numericRefinement) in numericRefinementMap {
                if let widgets = refinableDelegateMap[refinementName] {
                    for widget in widgets {
                        widget.onRefinementChange?(numerics: numericRefinement)
                    }
                }
            }
        }
    }

    private func callSpecificFacetChanges(facetRefinementMap: [String: [FacetRefinement]]?) {
        if let facetRefinementMap = facetRefinementMap {
            for (refinementName, facetRefinement) in facetRefinementMap {
                if let widgets = refinableDelegateMap[refinementName] {
                    for widget in widgets {
                        widget.onRefinementChange?(facets: facetRefinement)
                    }
                }
            }
        }
    }

    internal func search(with searchText: String) {
        searcher.params.query = searchText
        searcher.search()
    }
}

extension InstantSearch: UISearchResultsUpdating {

    @objc public func add(searchController: UISearchController) {
        searchController.searchResultsUpdater = self
    }

    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        search(with: searchText)
    }

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }

        search(with: searchText)
    }
}

extension InstantSearch: UISearchBarDelegate {
    @objc public func add(searchBar: UISearchBar) {
        searchBar.delegate = self
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(with: searchText)
    }
}
