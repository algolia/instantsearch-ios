//
//  MultiIndexSearchConnector+UIKit.swift
//  
//
//  Created by Vladislav Fitc on 30/07/2020.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(macOS))
import UIKit

public extension MultiIndexSearchConnector {

  @available(iOS 13.0, *)
  init<HC: MultiIndexHitsController>(searcher: MultiIndexSearcher,
                                     indexModules: [MultiIndexHitsConnector.IndexModule],
                                     searchController: UISearchController,
                                     hitsController: HC) {
    let queryInputInteractor = QueryInputInteractor()
    let textFieldController = TextFieldController(searchBar: searchController.searchBar)
    self.init(searcher: searcher,
              indexModules: indexModules,
              hitsController: hitsController,
              queryInputInteractor: queryInputInteractor,
              queryInputController: textFieldController)
  }

  @available(iOS 13.0, *)
  init<HC: MultiIndexHitsController>(appID: ApplicationID,
                                     apiKey: APIKey,
                                     indexModules: [MultiIndexHitsConnector.IndexModule],
                                     searchController: UISearchController,
                                     hitsController: HC) {
    let searcher = MultiIndexSearcher(appID: appID,
                                      apiKey: apiKey,
                                      indexNames: indexModules.map(\.indexName))
    self.init(searcher: searcher,
              indexModules: indexModules,
              searchController: searchController,
              hitsController: hitsController)
  }

}

#endif
