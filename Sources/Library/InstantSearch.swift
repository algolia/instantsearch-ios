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

/// Main class used for interacting with the InstantSearch library.
/// The most important thing that it does is binding the Searcher/Index to the widgets.
/// It also takes care of managing search components: `UISearchBar` and `UISearchController`.
@objc public class InstantSearch: NSObject, SearcherDelegate {

    /// The singleton reference of InstantSearch.
    /// It is advised to use this shared reference in case you're dealing with a single index in your app.
    public static let shared = InstantSearch()

    // MARK: - Properties

    // All widgets, including the specific ones such as refinementControlWidget.
    // We use a weak set so that we don't retain the views. 
    // The lifecycle of a view is not our concern, this should be left to VC.
    private var resultingDelegates = WeakSet<ResultingDelegate>()
    private var resettableDelegates = WeakSet<ResettableDelegate>()
    private var refinableDelegates = WeakSet<RefinableDelegate>()
    private var refinableDelegateMap = [String: WeakSet<RefinableDelegate>]()

    /// The Searcher used by this InstantSearch.
    public var searcher: Searcher!

    /// The search parameters of the Searcher.
    ///
    /// + Note: This is just a quick access to `searcher.params`.
    public var params: SearchParameters {
        return searcher.params
    }

    // This helps specify the viewmodel associated with a particular WidgetV.
    private lazy var viewModelFetcher: ViewModelFetcher = {
        return ViewModelFetcher()
    }()

    // MARK: - Init and Configure

    private override init() {
        super.init()
        InstantSearch._updateClientUserAgents
    }
    
    /// Add the library's version to the client's user agents, if not already present.
    private static let _updateClientUserAgents: Void = {
        let bundleInfo = Bundle(for: InstantSearch.self).infoDictionary!
        let name = bundleInfo["CFBundleName"] as! String
        let version = bundleInfo["CFBundleShortVersionString"] as! String
        let libraryVersion = LibraryVersion(name: name, version: version)
        Client.addUserAgent(libraryVersion)
    }()

    /// Create a new InstantSearch reference with the given configurations.
    ///
    /// - parameter appID: the Algolia AppID.
    /// - parameter apiKey: the Algolia ApiKey.
    /// - parameter index: the name of the index.
    public convenience init(appID: String, apiKey: String, index: String) {
        self.init()
        self.configure(appID: appID, apiKey: apiKey, index: index)
    }

    /// Create a new InstantSearch reference.
    ///
    /// - parameter searcher: the `Searcher` used by InstantSearch
    public convenience init(searcher: Searcher) {
        self.init()
        configure(searcher: searcher)
    }

    /// Configure the InstantSearch reference with the given configurations.
    ///
    /// - parameter appID: the Algolia AppID.
    /// - parameter apiKey: the Algolia ApiKeyl
    /// - parameter index: the name of the index.
    @objc public func configure(appID: String, apiKey: String, index: String) {
        let client = Client(appID: appID, apiKey: apiKey)
        let index = client.index(withName: index)
        let searcher = Searcher(index: index)
        configure(searcher: searcher)
    }

    // Helper method to configure the searcher, assign the searcher delegate to the InstantSearch reference,
    // and subscribe to Notifications that are interesting to InstantSearch.
    private func configure(searcher: Searcher) {
        self.searcher = searcher
        self.searcher.delegate = self

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reset),
                                               name: clearAllFiltersNotification,
                                               object: searcher.params)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onRefinementNotification(notification:)),
                                               name: Searcher.RefinementChangeNotification,
                                               object: searcher.params)
    }

    // MARK: Add widget methods

    /// Register all InstantSearch widgets inside a particular view, and then execute a search to Algolia
    ///
    /// - param view: the view containnig the InstantSearch widgets.
    ///
    /// + Note: InstantSearch widgets are simply the components that implement the `AlgoliaWidget` marker protocol.
    @objc public func registerAllWidgets(in view: UIView) {
        registerAllWidgets(in: view, doSearch: true)
    }
    
    /// Register all InstantSearch widgets inside a particular view.
    ///
    /// - param view: the view containnig the InstantSearch widgets.
    /// - param doSearch: do a new search to Algolia if true (default), nothing otherwise.
    ///
    /// + Note: InstantSearch widgets are simply the components that implement the `AlgoliaWidget` marker protocol.
    @objc public func registerAllWidgets(in view: UIView, doSearch: Bool = true) {
        registerWidgets(in: view)

        // After added all widgets, the widgets might have added
        // parameters to the searcher.params. So we need to trigger a new search.
        if doSearch {
            self.searcher.search()
        }
    }

    // Recursively iterate the sub views in order to find `AlgoliaWidget` components.
    private func registerWidgets(in view: UIView) {

        // Get the subviews of the view
        let subviews = view.subviews

        // Return if there are no subviews
        if subviews.isEmpty {
            return
        }

        for subView in subviews as [UIView] {

            if let algoliaWidget = subView as? AlgoliaWidget {
                register(widget: algoliaWidget, doSearch: false)
            }

            // List the subviews of subview
            registerWidgets(in: subView)
        }
    }

    /// Register a widget to InstantSearch.
    ///
    /// - param widget: the `AlgoliaWidget` to be registered to InstantSearch.
    ///
    /// + Note: if `doSearch` parameter is not specified, then we will automatically do a search if the `AlgoliaWidget`
    /// is an "input control" (changes the params of the Searcher), otherwise we don't do a search.
    @objc public func register(widget: AlgoliaWidget) {

        if widget is RefinementViewDelegate {
            register(widget: widget, doSearch: true)
        } else {
            register(widget: widget, doSearch: false)
        }

    }

    /// Register a widget to InstantSearch.
    ///
    /// - param widget: the `AlgoliaWidget` to be registered to InstantSearch.
    /// - param doSearch: whether or not to do a new search to Algolia after adding the widget.
    @objc public func register(widget: AlgoliaWidget, doSearch: Bool) {

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

    // Binds the widgetVM to the different events emitted by the Searcher.
    // We do this binding by adding the WidgetVM to the corresponding delegates
    // owned by InstantSearch, as well as assigning the Searcher to the VMs who implement `SearchableViewModel`.
    // The list of delegates are:
    //
    // - ResultingDelegate: to send results coming from Algolia's search
    // - resettableDelegate: to send reset/clear event
    // - refinableDelegate: to send changes to the Searcher's parameters.
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

            let attribute = refinableWidget.attribute

            if refinableDelegateMap[attribute] == nil {
                refinableDelegateMap[attribute] = WeakSet<RefinableDelegate>()
            }

            refinableDelegateMap[attribute]!.add(refinableWidget)
        }
    }

    // MARK: - Notification Observers

    /// Send reset event to all registered viewModels that implement the `resettableDelegate` protocol.
    func reset() {
        for algoliaWidget in resettableDelegates {
            algoliaWidget.onReset()
        }
    }

    /// Refinement Notification handler sent when either a Numeric or a Facet Refinement is changed.
    func onRefinementNotification(notification: Notification) {
        let numericRefinementMap = notification.userInfo?[Searcher.userInfoNumericRefinementChangeKey] as? [String: [NumericRefinement]]
        let facetRefinementMap = notification.userInfo?[Searcher.userInfoFacetRefinementChangeKey] as? [String: [FacetRefinement]]

        callGeneralRefinementChanges(numericRefinementMap: numericRefinementMap, facetRefinementMap: facetRefinementMap)
        callSpecificNumericChanges(numericRefinementMap: numericRefinementMap)
        callSpecificFacetChanges(facetRefinementMap: facetRefinementMap)
    }

    // MARK: - SearcherDelegate

    /// Delegate method called when new search results arrive from Algolia
    /// This function forwards all results, errors and userInfo to the resultDelegates.
    public func searcher(_ searcher: Searcher, didReceive results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        for algoliaWidget in resultingDelegates {
            algoliaWidget.on(results: results, error: error, userInfo: userInfo)
        }
    }

    // MARK: - Param Notifications Methods
    
    // Forwards any param change to the widget implementing the `RefinableDelegate` protocol.
    private func callGeneralRefinementChanges(
        numericRefinementMap: [String: [NumericRefinement]]?,
        facetRefinementMap: [String: [FacetRefinement]]?) {
        for refinementControlWidget in refinableDelegates {
            refinementControlWidget.onRefinementChange?(numericMap: numericRefinementMap)
            refinementControlWidget.onRefinementChange?(facetMap: facetRefinementMap)
        }
    }

    // Forwards any numeric param change to the widget implementing the `RefinableDelegate` protocol.
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

    // Forwards any facet param change to the widget implementing the `RefinableDelegate` protocol.
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
    
    // MARK: - Helper methods
    
    internal func search(with searchText: String) {
        searcher.params.query = searchText
        searcher.search()
    }
}

extension InstantSearch: UISearchResultsUpdating {

    /// Forwards a `SearchController` to `InstantSearch` so that it takes care of updating search results
    /// on every new keystroke inside the `UISearchBar` linked to it.
    @objc public func register(searchController: UISearchController) {
        searchController.searchResultsUpdater = self
    }

    /// Handler called on each keystroke change in the `UISearchBar`
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        search(with: searchText)
    }

    /// Handler called when searchBar becomes first responder
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }

        search(with: searchText)
    }
}

extension InstantSearch: UISearchBarDelegate {
    /// Forwards a `UISearchBar` to `InstantSearch` so that it takes care of updating search results
    /// on every new keystroke
    @objc public func register(searchBar: UISearchBar) {
        searchBar.delegate = self
    }

    /// Handler called on each keystroke change in the `UISearchBar`
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {        
        search(with: searchText)
    }
}
