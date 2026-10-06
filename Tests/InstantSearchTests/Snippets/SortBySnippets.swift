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
    func widgetSnippet() throws {
      let searcher: HitsSearcher = try .init(appID: "YourApplicationID",
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
        default: return indexName
        }
      }

      _ = sortByConnector
    }

    func advancedSnippet() throws {
      let searcher: HitsSearcher = try .init(appID: "YourApplicationID",
                                         apiKey: "YourSearchOnlyAPIKey",
                                         indexName: "indexDefault")

      let alertController = UIAlertController(title: "Change Index",
                                              message: "Please select a new index",
                                              preferredStyle: .actionSheet)
      let selectIndexController: SelectIndexController = .init(alertController: alertController)

      let indexSegmentInteractor: SortByInteractor = .init(items: [
        0: "indexDefault",
        1: "indexAscendingOrder",
        2: "indexDescendingOrder"
      ])

//    indexSegmentInteractor.connectSearcher(searcher: searcher)

      // The explicit connection type disambiguates from the deprecated
      // `IndexSegmentInteractor.connectController(_:presenter:)` overload.
      let connection: SortByInteractor.ControllerConnection = indexSegmentInteractor.connectController(selectIndexController) { indexName -> String in
        switch indexName {
        case "indexDefault": return "Default"
        case "indexAscendingOrder": return "Year Asc"
        case "indexDescendingOrder": return "Year Desc"
        default: return indexName
        }
      }

      _ = connection
      _ = searcher
    }
  }
#endif
