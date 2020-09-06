//
//  SortBySnippets.swift
//  
//
//  Created by Vladislav Fitc on 04/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class SortBySnippets {
  
  let sortByConnector: SortByConnector = .init(searcher: .init(appID: "", apiKey: "", indexName: ""), indicesNames: [])
  let indexSegmentInteractor: IndexSegmentInteractor = .init(items: [:])
    
  func widgetSnippet() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "indexDefault")

    let sortByConnector: SortByConnector = .init(searcher: searcher,
                                                 indicesNames: ["indexDefault",
                                                                "indexAscendingOrder",
                                                                "indexDescendingOrder"],
                                                 selected: 0)
    _ = sortByConnector
  }
  
  func advancedSnippet() {

    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "indexDefault")
    
    let indexDefault = searcher.client.index(withName: "indexDefault")
    let indexAscendingOrder = searcher.client.index(withName: "indexAscendingOrder")
    let indexDescendingOrder = searcher.client.index(withName: "indexDescendingOrder")

    let indexSegmentInteractor: IndexSegmentInteractor = .init(items: [
        0 : indexDefault,
        1 : indexAscendingOrder,
        2 : indexDescendingOrder
    ])

    indexSegmentInteractor.connectSearcher(searcher: searcher)

  }
  
  func connectControllerConnector() {
    let sortByConnector: SortByConnector = /*...*/ self.sortByConnector
    let alertController = UIAlertController(title: "Change Index",
                                            message: "Please select a new index",
                                            preferredStyle: .actionSheet)
    let selectIndexController: SelectIndexController = .init(alertController: alertController)
    
    sortByConnector.interactor.connectController(selectIndexController) { index -> String in
      switch index.name {
      case "indexDefault": return "Default"
      case "indexAscendingOrder": return "Year Asc"
      case "indexDescendingOrder": return "Year Desc"
      default: return index.name.rawValue
      }
    }

  }
  
  func connectControllerInteractor() {
    let indexSegmentInteractor: IndexSegmentInteractor = /*...*/ self.indexSegmentInteractor
    let alertController = UIAlertController(title: "Change Index",
                                            message: "Please select a new index",
                                            preferredStyle: .actionSheet)
    let selectIndexController: SelectIndexController = .init(alertController: alertController)
    
    indexSegmentInteractor.connectController(selectIndexController) { index -> String in
      switch index.name {
      case "indexDefault": return "Default"
      case "indexAscendingOrder": return "Year Asc"
      case "indexDescendingOrder": return "Year Desc"
      default: return index.name.rawValue
      }
    }
    
    _ = selectIndexController
  }
  
}
