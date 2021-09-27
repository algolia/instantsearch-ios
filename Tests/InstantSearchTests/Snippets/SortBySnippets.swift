//
//  SortBySnippets.swift
//  
//
//  Created by Vladislav Fitc on 04/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && !os(watchOS)
import UIKit

class SortBySnippets {
      
  func widgetSnippet() {
    let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "indexDefault")
    let alertController = UIAlertController(title: "Change Index",
                                            message: "Please select a new index",
                                            preferredStyle: .actionSheet)
    let selectIndexController: SelectIndexController = .init(alertController: alertController)
    let sortByConnector: SortByConnector = .init(searcher: searcher,
                                                 indicesNames: ["indexDefault",
                                                                "indexAscendingOrder",
                                                                "indexDescendingOrder"],
                                                 selected: 0,
                                                 controller: selectIndexController) { indexName -> String in
      switch indexName {
      case "indexDefault": return "Default"
      case "indexAscendingOrder": return "Year Asc"
      case "indexDescendingOrder": return "Year Desc"
      default: return indexName.rawValue
      }
    }
                                                  
    _ = sortByConnector
  }
  
  func advancedSnippet() {

    let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "indexDefault")
    
    let indexDefault = searcher.service.client.index(withName: "indexDefault")
    let indexAscendingOrder = searcher.service.client.index(withName: "indexAscendingOrder")
    let indexDescendingOrder = searcher.service.client.index(withName: "indexDescendingOrder")
    let alertController = UIAlertController(title: "Change Index",
                                            message: "Please select a new index",
                                            preferredStyle: .actionSheet)
    let selectIndexController: SelectIndexController = .init(alertController: alertController)

    let indexSegmentInteractor: IndexSegmentInteractor = .init(items: [
        0 : indexDefault,
        1 : indexAscendingOrder,
        2 : indexDescendingOrder
    ])

    indexSegmentInteractor.connectSearcher(searcher: searcher)
    
    indexSegmentInteractor.connectController(selectIndexController) { index -> String in
      switch index.name {
      case "indexDefault": return "Default"
      case "indexAscendingOrder": return "Year Asc"
      case "indexDescendingOrder": return "Year Desc"
      default: return index.name.rawValue
      }
    }

  }
    
}
#endif
