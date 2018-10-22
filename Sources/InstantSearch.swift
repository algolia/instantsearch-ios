//
//  InstantSearch.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
@_exported import InstantSearchCore
@_exported import InstantSearchClient
import UIKit

/// Main class used for interacting with the InstantSearch library.
/// The most important thing that it does is binding the Searcher/Index to the widgets.
/// It also takes care of managing search components: `UISearchBar` and `UISearchController`.
@objcMembers public class InstantSearch: NSObject, SearcherDelegate {
    
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
    
    private var multiIndexResultingDelegates: [SearcherId: WeakSet<ResultingDelegate>] = [:]
    //private var multiIndexRefinableDelegates: [IndexId: [String: WeakSet<RefinableDelegate>]] = [:]
    
    /// The Searchers used in the case of multi-indexing.
    public var searchers: [SearcherId: Searcher]
    
    /// The Searcher used in the case of single-indexing.
    /// + NOTE: It is safer to use the getSearcher() method
    /// + WARNING: Don't use this in the case of configuring with multi-index.
    public var searcher: Searcher!
  
    public var history: LocalHistory = {
      // Store the history in a `history.dat` file inside the `Application Support` directory.
      let appSupportDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
      let historyFile = URL(fileURLWithPath: appSupportDir).appendingPathComponent("history.dat").path
      let history = LocalHistory(filePath: historyFile)
      return history
    }()
    
    private var isMultiIndexActive = false
  
    public var recordHistory = false
  
  public var debuggingEnabled = false {
    didSet {
      if searcher != nil {
        searcher.debuggingEnabled = debuggingEnabled
      }
      searchers.forEach { (_, searcher) in
        searcher.debuggingEnabled = debuggingEnabled
      }
    }
  }
  
    //TODO: these 2 fields below might have to be moved to another class dedicated for state management of searcher Ids.
  
    @objc dynamic public var selectedSearcherId: SearcherId?
  
    public var selectedSearcher: Searcher? {
      guard let selectedSearcherId = selectedSearcherId else {
        print("need to fill the selected SearchedId to use this")
        return nil
      }
      return getSearcher(named: selectedSearcherId.index, withId: selectedSearcherId.variant)
    }
  
    /// The search parameters of the Searcher. This is just a quick access to `searcher.params`.
    /// + NOTE: It is safer to use the getSearcher().params method
    /// + WARNING: Don't use this in the case of configuring with multi-index.
    public var params: SearchParameters {
        return searcher.params
    }
    
    // This helps specify the viewmodel associated with a particular WidgetV.
    private lazy var viewModelFetcher: ViewModelFetcher = {
        return ViewModelFetcher()
    }()
    
    private static let instantSearchUserAgent = "InstantSearch iOS"
    
    // MARK: - Init and Configure
    
    private override init() {
        self.searchers = [:]
        super.init()
        InstantSearch._updateClientUserAgents
    }
    
    /// Add the library's version to the client's user agents, if not already present.
    private static let _updateClientUserAgents: Void = {
        let bundleInfo = Bundle(for: InstantSearch.self).infoDictionary!
        let name = instantSearchUserAgent
        let version = bundleInfo["CFBundleShortVersionString"] as! String
        let libraryVersion = LibraryVersion(name: name, version: version)
        Client.addUserAgent(libraryVersion)
    }()
    
    /// Create a new InstantSearch reference with the given configurations.
    ///
    /// - parameter appID: the Algolia AppID.
    /// - parameter apiKey: the Algolia ApiKey.
    /// - parameter index: the name of the index.
    @objc public convenience init(appID: String, apiKey: String, index: String) {
        self.init()
        self.configure(appID: appID, apiKey: apiKey, index: index)
    }
    
    /// Create a new InstantSearch reference.
    ///
    /// - parameter searcher: the `Searcher` used by InstantSearch
    @objc public convenience init(searcher: Searcher) {
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
    
    // Multi-Index init
    
    /// Create a new InstantSearch reference with the given configurations.
    ///
    /// - parameter appID: the Algolia AppID.
    /// - parameter apiKey: the Algolia ApiKey.
    /// - parameter indexIds: the identifications for each index
    @objc public convenience init(appID: String, apiKey: String, searcherIds: [SearcherId]) {
        self.init()
        self.configure(appID: appID, apiKey: apiKey, searcherIds: searcherIds)
    }
    
    /// Create a new InstantSearch reference with the given configurations.
    ///
    /// - parameter searchables: an array of searchables
    /// - parameter searchersIds: an array of searcherId that identifies a specific index
    @objc public convenience init(searchables: [Searchable], searcherIds: [SearcherId]) {
        self.init()
        self.configure(searchables: searchables, searcherIds: searcherIds)
    }
    
    /// Configure the InstantSearch reference with the given configurations.
    ///
    /// - parameter appID: the Algolia AppID.
    /// - parameter apiKey: the Algolia ApiKey.
    /// - parameter indexIds: identifiers for the different indices.
    @objc public func configure(appID: String, apiKey: String, searcherIds: [SearcherId]) {
        let client = Client(appID: appID, apiKey: apiKey)
        
        for searcherId in searcherIds {
            let index = client.index(withName: searcherId.index)
            let searcher = Searcher(index: index)
            searcher.indexName = searcherId.index
            searcher.variant = searcherId.variant
            searchers[searcherId] = searcher
        }
        
        configureMulti(searchers: searchers)
    }
    
    /// Configure the InstantSearch reference with the given configurations.
    ///
    /// - parameter searchables: an array of searchables
    /// - parameter searchersIds: an array of searcherId that identifies a specific index
    @objc public func configure(searchables: [Searchable], searcherIds: [SearcherId]) {
        for (searchable, searcherId) in zip(searchables, searcherIds) {
            let searcher = Searcher(index: searchable)
            searcher.indexName = searcherId.index
            searcher.variant = searcherId.variant
            searchers[searcherId] = searcher
        }
        
        configureMulti(searchers: searchers)
    }
    
    private func configureMulti(searchers: [SearcherId: Searcher]) {
        isMultiIndexActive = true
        for (_, searcher) in searchers {
            searcher.delegate = self
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(reset),
                                                   name: clearAllFiltersNotification,
                                                   object: searcher.params)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(onRefinementNotification(notification:)),
                                                   name: Searcher.RefinementChangeNotification,
                                                   object: searcher.params)
        }
    }
    
    /// Get the searcher associated to the index used for InstantSearch
    @objc public func getSearcher() -> Searcher {
        if isMultiIndexActive {
            fatalError("Since you are using multi-index, you should use getSearcher(named:withId:)")
        }
        
        return searcher
    }
    
    /// Get the searcher associated to the specific index with name and id used for InstantSearch
    @objc public func getSearcher(named name: String, withId id: String = "") -> Searcher? {
        return searchers[SearcherId(index: name, variant: id)]
    }
    
    // MARK: Caching
    
    /// Whether the search cache is enabled on this index. Default: `false`.
    ///
    @objc public var searchCacheEnabled: Bool = false {
        didSet {
            if isMultiIndexActive {
                searchers.forEach {
                    if let index = $1.index as? Index {
                        index.searchCacheEnabled = searchCacheEnabled
                    }
                }
            } else {
                if let index = getSearcher().index as? Index {
                    index.searchCacheEnabled = searchCacheEnabled
                }
            }
        }
    }
    
    /// Expiration delay for items in the search cache. Default: 2 minutes.
    ///
    /// + Note: The delay is a minimum threshold. Items may survive longer in cache.
    ///
    @objc public var searchCacheExpiringTimeInterval: TimeInterval = 120 {
        didSet {
            if isMultiIndexActive {
                searchers.forEach {
                    if let index = $1.index as? Index {
                        index.searchCacheExpiringTimeInterval = searchCacheExpiringTimeInterval
                    }
                }
            } else {
                if let index = getSearcher().index as? Index {
                    index.searchCacheExpiringTimeInterval = searchCacheExpiringTimeInterval
                }
            }
        }
    }
    
    @objc public func searchCacheEnabled(_ searchCacheEnabled: Bool, for searcherIds: [SearcherId]) {
        guard isMultiIndexActive else { return }
        
        searcherIds.forEach { (searcherId) in
            let searcher = searchers.filter {
                $0.key == searcherId
            }.first // Should only have one searcher associated to the specific searcherId
            
            if let index = searcher?.value.index as? Index {
                index.searchCacheEnabled = searchCacheEnabled
            }
        }
    }
    
    @objc public func searchCacheExpiringTimeInterval(_ searchCacheExpiringTimeInterval: TimeInterval, for searcherIds: [SearcherId]) {
        guard isMultiIndexActive else { return }
        
        searcherIds.forEach { (searcherId) in
            let searcher = searchers.filter {
                $0.key == searcherId
            }.first // Should only have one searcher associated to the specific searcherId
            
            if let index = searcher?.value.index as? Index {
                index.searchCacheExpiringTimeInterval = searchCacheExpiringTimeInterval
            }
        }
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
            search()
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
        if isMultiIndexActive {
            bind(searchers: searchers, to: widgetVM)
        } else {
            bind(searcher: searcher, to: widgetVM)
        }
        
        // After a widget is added, we can decide to make a search. This is when
        // a widget modifies the state of the searcher.params
        if doSearch {
          // TODO: more efficient search need to be done: only do a search to
          // the corresponding searcher(s) of the widget
            search()
        }
    }
    
    /// Register a viewModel to InstantSearch so that it subscribes to search events.
    ///
    /// - param widget: the `AlgoliaWidget` to be registered to InstantSearch.
    /// - param doSearch: whether or not to do a new search to Algolia after adding the widget.
    @objc public func register(viewModel widgetVM: AlgoliaViewModel) {
        if isMultiIndexActive {
            bind(searchers: searchers, to: widgetVM)
        } else {
            bind(searcher: searcher, to: widgetVM)
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
            registerAsRefinableDelegate(widget: refinableWidget)
        }
    }
    
    private func bind(searchers: [SearcherId: Searcher], to widgetVM: Any?) {
        
        if let widgetVM = widgetVM as? SearchableMultiIndexViewModel {
            
            // 1- Configure the searchers
            let searchersArray = searchers.map { $0.value }
            widgetVM.configure(withSearchers: searchersArray)
            
            // 2- Register Resulting Delegates
            if let resultingWidget = widgetVM as? ResultingDelegate {
                widgetVM.searcherIds.forEach({ (searcherId) in
                    registerAsResultingDelegate(widget: resultingWidget, with: searcherId)
                })
            }
        } else if let widgetVM = widgetVM as? SearchableIndexViewModel {
            
            if widgetVM is RefinableDelegate && widgetVM.searcherId.variant.isEmpty
                && widgetVM.searcherId.index.isEmpty {
                fatalError("When using multi-indexing, refinable widgets should target a specific index")
            }
            
            if !(widgetVM is MultiSearchableViewModel) && widgetVM.searcherId.index.isEmpty
                && widgetVM.searcherId.variant.isEmpty {
               fatalError("When using multi-indexing, All output widgets have to target a specific index")
            }
            
            // 1- Configure the searchers. If we don't specify an index name and index id,
            // it means we need to target all indices for this widget.
            if let widget = widgetVM as? MultiSearchableViewModel,
                widgetVM.searcherId.index.isEmpty,
                widgetVM.searcherId.variant.isEmpty {
                
                let searchersArray = searchers.map { $0.value }
                widget.configure(withSearchers: searchersArray)
            } else { // Else, target the specific index.
                let searcherId = SearcherId(index: widgetVM.searcherId.index, variant: widgetVM.searcherId.variant)
                guard let searcher = searchers[searcherId] else {
                    fatalError("Index name/Id not declared when configuring InstantSearch. Please make sure to add all of them.")
                }
                widgetVM.configure(with: searcher)
            }
            
            // 2- Register resulting delegates
            if let resultingWidget = widgetVM as? ResultingDelegate {
                let searcherId = SearcherId(index: widgetVM.searcherId.index, variant: widgetVM.searcherId.variant)
                registerAsResultingDelegate(widget: resultingWidget, with: searcherId)
            }
            
            // 3- Register Refinable delegates
            if let refinableWidget = widgetVM as? RefinableDelegate {
                registerAsRefinableDelegate(widget: refinableWidget)
            }
        }
    }
    
    fileprivate func registerAsRefinableDelegate(widget refinableWidget: RefinableDelegate) {
        refinableDelegates.add(refinableWidget)
        
        let attribute = refinableWidget.attribute
        
        if refinableDelegateMap[attribute] == nil {
            refinableDelegateMap[attribute] = WeakSet<RefinableDelegate>()
        }
        
        refinableDelegateMap[attribute]!.add(refinableWidget)
    }
    
    fileprivate func registerAsResultingDelegate(widget resultingDelegate: ResultingDelegate, with searcherId: SearcherId) {
        if multiIndexResultingDelegates[searcherId] == nil {
            multiIndexResultingDelegates[searcherId] = WeakSet<ResultingDelegate>()
        }
        
        multiIndexResultingDelegates[searcherId]!.add(resultingDelegate)
    }
    
    // MARK: - Notification Observers
    
    /// Send reset event to all registered viewModels that implement the `resettableDelegate` protocol.
    @objc func reset() {
        for algoliaWidget in resettableDelegates {
            algoliaWidget.onReset()
        }
    }
    
    /// Refinement Notification handler sent when either a Numeric or a Facet Refinement is changed.
    @objc func onRefinementNotification(notification: Notification) {
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
        
        if isMultiIndexActive {
            let searcherId = SearcherId(index: searcher.indexName, variant: searcher.variant)
            if let multiIndexResultingDelegates = self.multiIndexResultingDelegates[searcherId] {
                for algoliaWidget in multiIndexResultingDelegates {
                    algoliaWidget.on(results: results, error: error, userInfo: userInfo)
                }
            } // else the widget is not mounted yet on the screen
        } else {
            for algoliaWidget in resultingDelegates {
                algoliaWidget.on(results: results, error: error, userInfo: userInfo)
            }
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
    
    public func search(with searchText: String) {
        
        if isMultiIndexActive {
            for (_, searcher) in searchers {
                searcher.params.query = searchText
            }
        } else {
            searcher.params.query = searchText
        }
        
        search()
    }
    
    public func search() {
        if isMultiIndexActive {
            for (_, searcher) in searchers {
                searcher.search()
            }
        } else {
            self.searcher.search()
        }
    }
  
  public func search(with searchText: String, in searcherIds: [SearcherId]) {
    searcherIds.forEach { (searcherId) in
      if let searcher = searchers[searcherId] {
        searcher.params.query = searchText
        searcher.search()
      } else {
        print("tried to search with inexistent searchId")
      }
    }
  }
  
  public func clearParameters(in searcherIds: [SearcherId]) {
    searcherIds.forEach { (searcherId) in
      if let searcher = searchers[searcherId] {
        searcher.reset()
      } else {
        print("tried to clear params with inexistent searchId")
      }
    }
  }
  
  public func clearParameters(exceptIn searcherIds: [SearcherId]) {
    searchers.forEach { (searcherId, searcher) in
      if !searcherIds.contains(searcherId) {
        searcher.reset()
      }
    }
  }
  
  public func clearParameters() {
    if isMultiIndexActive {
      for (_, searcher) in searchers {
        searcher.reset()
      }
    } else {
      self.searcher.reset()
    }
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

extension InstantSearch {
  public func appendHistory(queryText: String) {
    guard recordHistory else {
      print("need to set recordHistory to true to record history")
      return
    }
    
    let params = SearchParameters()
    params.query = queryText
    history.add(params)
    history.saveAsync()
  }
  
  public func clearAllHistory() {
    history.clear()
  }
  
  public func clearQueryInHistory(queryText: String) {
    let filteredQueries = history.contents.filter { (query) -> Bool in
      return query != queryText
    }
    
    clearAllHistory()
    
    filteredQueries.forEach { (query) in
      let params = SearchParameters()
      params.query = query
      history.add(params)
    }
  }
  
  public func searchHistory(queryText: String, maxHits: Int = 2) -> [HistoryHit] {
    let params = SearchParameters()
    params.query = queryText
    let options = HistorySearchOptions()
    options.maxHits =  maxHits
    let hits = history.search(query: params, options: options)
    
    return hits
  }
}
