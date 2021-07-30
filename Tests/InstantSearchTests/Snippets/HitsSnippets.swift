//
//  HitsSnippets.swift
//  
//
//  Created by Vladislav Fitc on 01/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit)
import UIKit

class HitsSnippets {
  
  private let hitsInteractor: HitsInteractor<CustomHitModel> = .init()
  private let hitsConnector = HitsConnector<CustomHitModel>(appID: "YourApplicationID",
                                                apiKey: "YourSearchOnlyAPIKey",
                                                indexName: "YourIndexName")

  
  struct CustomHitModel: Codable {
    let name: String
  }
  
  struct CustomCellConfigurator: TableViewCellConfigurable {

    let model: CustomHitModel
    
    init(model: CustomHitModel, indexPath: IndexPath) {
      self.model = model
    }
    
    func configure(_ cell: UITableViewCell) {
      cell.textLabel?.text = model.name
    }

  }
  
  typealias CustomHitsTableViewController = HitsTableViewController<CustomCellConfigurator>
  
  class MoreCustomHitsTableViewController: HitsTableViewController<CustomCellConfigurator> {
    
  }
  
  func widgetSnippet() {
    let filterState: FilterState  = .init()
    let hitsTableViewController = CustomHitsTableViewController()
    let hitsConnector = HitsConnector<CustomHitModel>(appID: "YourApplicationID",
                                                      apiKey: "YourSearchOnlyAPIKey",
                                                      indexName: "YourIndexName",
                                                      filterState: filterState,
                                                      controller: hitsTableViewController)
    
    
    hitsConnector.searcher.search()
  }
  
  func advancedSnippet() {
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    
    let filterState: FilterState  = .init()
    let hitsInteractor: HitsInteractor<CustomHitModel> = .init()
    let hitsTableViewController = CustomHitsTableViewController()

    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectFilterState(filterState)
    hitsInteractor.connectController(hitsTableViewController)
    searcher.search()
  }
  
}
#endif
