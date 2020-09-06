//
//  HitsSnippets.swift
//  
//
//  Created by Vladislav Fitc on 01/09/2020.
//

import Foundation
import InstantSearch
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

    let hitsConnector = HitsConnector<CustomHitModel>(appID: "YourApplicationID",
                                                  apiKey: "YourSearchOnlyAPIKey",
                                                  indexName: "YourIndexName",
                                                  filterState: filterState)
    

    hitsConnector.searcher.search()

  }
  
  func advancedSnippet() {
    let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "YourApplicationID",
                                                            apiKey: "YourSearchOnlyAPIKey",
                                                            indexName: "YourIndexName")
    let filterState: FilterState  = .init()
    let hitsInteractor: HitsInteractor<CustomHitModel> = .init()
    
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectFilterState(filterState)
    searcher.search()
  }
  
  func connectControllerConnector() {
    let hitsConnector: HitsConnector = /*...*/ self.hitsConnector
    let hitsTableViewController = CustomHitsTableViewController()
    hitsConnector.interactor.connectController(hitsTableViewController)
  }
  
  func connectControllerInteractor() {
    let hitsInteractor: HitsInteractor<CustomHitModel> = /*...*/ self.hitsInteractor
    let hitsTableViewController = CustomHitsTableViewController()
    hitsInteractor.connectController(hitsTableViewController)
  }
  
}
