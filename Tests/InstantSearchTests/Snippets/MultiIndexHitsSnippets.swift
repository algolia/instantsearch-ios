//
//  MultiIndexHitsSnippets.swift
//  
//
//  Created by Vladislav Fitc on 02/09/2020.
//

import Foundation
import InstantSearch
import UIKit

class MultiIndexHitsSnippets {
  
  private let hitsInteractor: MultiIndexHitsInteractor = .init(hitsInteractors: [])
  private let hitsConnector: MultiIndexHitsConnector = .init(appID: "", apiKey: "", indexModules: [])
  
  struct Actor: Codable {}
  struct Movie: Codable {}
  
  func widgetSnippet() {
    
    let actorHitsInteractor: HitsInteractor<Actor> = .init(infiniteScrolling: .off)
    let movieHitsInteractor: HitsInteractor<Movie> = .init(infiniteScrolling: .off)

    let movieFilterState: FilterState = .init()
    
    let multiIndexHitsConnector = MultiIndexHitsConnector(appID: "YourApplicationID",
                                                          apiKey: "YourSearchOnlyAPIKey",
                                                          indexModules: [
                                                            .init(indexName: "actors",
                                                                  hitsInteractor: actorHitsInteractor),
                                                            .init(indexName: "movies",
                                                                  hitsInteractor: movieHitsInteractor,
                                                                  filterState: movieFilterState)
                                                          ])
    
    _ = multiIndexHitsConnector
  }
  
  func advancedSnippet() {
    let searcher: MultiIndexSearcher = .init(appID: "YourApplicationID",
                                             apiKey: "YourSearchOnlyAPIKey",
                                             indexNames: ["actors", "movies"])
    
    let actorHitsInteractor: HitsInteractor<Actor> = .init(infiniteScrolling: .off)
    let movieHitsInteractor: HitsInteractor<Movie> = .init(infiniteScrolling: .off)
    let hitsInteractor: MultiIndexHitsInteractor = .init(hitsInteractors: [actorHitsInteractor, movieHitsInteractor])
    
    hitsInteractor.connectSearcher(searcher)
    
    let movieFilterState: FilterState = .init()
    
    movieHitsInteractor.connectFilterState(movieFilterState)
    searcher.connectFilterState(movieFilterState, withQueryAtIndex: 1)

  }
  
  struct ActorCellConfigurator: TableViewCellConfigurable {
    
    let model: Actor
    
    init(model: Actor, indexPath: IndexPath) {
      self.model = model
    }
    
    func configure(_ cell: UITableViewCell) {
      
    }
    
  }
  
  struct MovieCellConfigurator: TableViewCellConfigurable {
    
    let model: Movie
    
    init(model: Movie, indexPath: IndexPath) {
      self.model = model
    }
    
    func configure(_ cell: UITableViewCell) {
      
    }
    
  }

  
  func connectViewsSeparately() {
    let actorHitsInteractor: HitsInteractor<Actor> = .init(infiniteScrolling: .off)
    let actorsTableViewController = HitsTableViewController<ActorCellConfigurator>()
    actorHitsInteractor.connectController(actorsTableViewController)

    let movieHitsInteractor: HitsInteractor<Movie> = .init(infiniteScrolling: .off)
    let moviesTableViewController = HitsTableViewController<MovieCellConfigurator>()
    movieHitsInteractor.connectController(moviesTableViewController)
    
    let hitsInteractor: MultiIndexHitsInteractor = .init(hitsInteractors: [actorHitsInteractor, movieHitsInteractor])
    
    _ = hitsInteractor
  }
  
  class MultiIndexHitsTableController: NSObject, MultiIndexHitsController {

    public let tableView: UITableView

    public weak var hitsSource: MultiIndexHitsSource?

    public init(tableView: UITableView) {
      self.tableView = tableView
    }

    public func reload() {
      tableView.reloadData()
    }

    public func scrollToTop() {
      guard tableView.numberOfRows(inSection: 0) != 0 else { return }
      let indexPath = IndexPath(row: 0, section: 0)
      self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }

  }
  
  func connectControllerConnector() {
    let hitsConnector: MultiIndexHitsConnector = /*...*/ self.hitsConnector
    let hitsTableViewController = MultiIndexHitsTableController(tableView: .init())
    hitsConnector.interactor.connectController(hitsTableViewController)
  }
  
  func connectControllerInteractor() {
    let hitsInteractor: MultiIndexHitsInteractor = /*...*/ self.hitsInteractor
    let hitsTableViewController = MultiIndexHitsTableController(tableView: .init())
    hitsInteractor.connectController(hitsTableViewController)
  }

}
