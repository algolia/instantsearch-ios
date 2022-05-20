//
//  SearchConnector+UIKit.swift
//  
//
//  Created by Vladislav Fitc on 30/07/2020.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(macOS))
import UIKit

public extension SearchConnector {

  init<HC: HitsController>(searcher: HitsSearcher,
                           searchController: UISearchController,
                           hitsInteractor: HitsInteractor<Record>,
                           hitsController: HC,
                           filterState: FilterState? = nil)  where HC.DataSource == HitsInteractor<Record> {
    let searchBoxInteractor = SearchBoxInteractor()
    if #available(iOS 13.0, *) {
      let textFieldController = TextFieldController(searchBar: searchController.searchBar)
      self.init(searcher: searcher,
                searchBoxInteractor: searchBoxInteractor,
                searchBoxController: textFieldController,
                hitsInteractor: hitsInteractor,
                hitsController: hitsController,
                filterState: filterState)
    } else {
      let searchBarController = SearchBarController(searchBar: searchController.searchBar)
      self.init(searcher: searcher,
                searchBoxInteractor: searchBoxInteractor,
                searchBoxController: searchBarController,
                hitsInteractor: hitsInteractor,
                hitsController: hitsController,
                filterState: filterState)
    }
  }

  init<HC: HitsController>(appID: ApplicationID,
                           apiKey: APIKey,
                           indexName: IndexName,
                           searchController: UISearchController,
                           hitsInteractor: HitsInteractor<Record>,
                           hitsController: HC,
                           filterState: FilterState? = nil) where HC.DataSource == HitsInteractor<Record> {
    let searcher = HitsSearcher(appID: appID,
                                       apiKey: apiKey,
                                       indexName: indexName)
    self.init(searcher: searcher,
              searchController: searchController,
              hitsInteractor: hitsInteractor,
              hitsController: hitsController,
              filterState: filterState)
  }

}
#endif
