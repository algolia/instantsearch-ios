//
//  SingleIndexSearchConnector+UIKit.swift
//  
//
//  Created by Vladislav Fitc on 30/07/2020.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(macOS))
import UIKit

public extension SingleIndexSearchConnector {

  @available(iOS 13.0, *)
  init<HC: HitsController>(searcher: SingleIndexSearcher,
                           searchController: UISearchController,
                           hitsInteractor: HitsInteractor<Record> = .init(),
                           hitsController: HC,
                           filterState: FilterState? = nil)  where HC.DataSource == HitsInteractor<Record> {
    let queryInputInteractor = QueryInputInteractor()
    let textFieldController = TextFieldController(searchBar: searchController.searchBar)
    self.init(searcher: searcher,
              queryInputInteractor: queryInputInteractor,
              queryInputController: textFieldController,
              hitsInteractor: hitsInteractor,
              hitsController: hitsController,
              filterState: filterState)
  }

  @available(iOS 13.0, *)
  init<HC: HitsController>(appID: ApplicationID,
                           apiKey: APIKey,
                           indexName: IndexName,
                           searchController: UISearchController,
                           hitsInteractor: HitsInteractor<Record> = .init(),
                           hitsController: HC,
                           filterState: FilterState? = nil) where HC.DataSource == HitsInteractor<Record> {
    let searcher = SingleIndexSearcher(appID: appID,
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
