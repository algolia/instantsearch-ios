//
//  MultiIndexSnippet.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 25/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class MultiIndexSnippetViewController: UIViewController {
    
  let searchBar: UISearchBar = .init()
  lazy var textFieldController: TextFieldController = .init(searchBar: searchBar)
  
  lazy var queryInputConnector: QueryInputConnector = .init(searcher: hitsInteractor.searcher, controller: textFieldController)

  
  lazy var hitsInteractor: MultiIndexHitsConnector = {
    let actorHitsInteractor: HitsInteractor<Actor> = .init(infiniteScrolling: .off)
    let movieHitsInteractor: HitsInteractor<Movie> = .init(infiniteScrolling: .off)
    let interactor = MultiIndexHitsInteractor(hitsInteractors: [actorHitsInteractor, movieHitsInteractor])
    return .init(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db", indexModules: [.init(indexName: "mobile_demo_actors", hitsInteractor: actorHitsInteractor), .init(indexName: "mobile_demo_movies", hitsInteractor: movieHitsInteractor)], controller: hitsTableViewController)
  }()
  
  let hitsTableViewController: HitsViewController = .init(style: .plain)
    
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    hitsInteractor.searcher.search()
  }
  
  func configureUI() {
    view.backgroundColor = .white
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 16
    stackView.axis = .vertical
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    stackView.isLayoutMarginsRelativeArrangement = true
    
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    searchBar.searchBarStyle = .minimal
    
    stackView.addArrangedSubview(searchBar)
    
    hitsTableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(hitsTableViewController.tableView)
    
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])

  }
  
}

extension MultiIndexSnippetViewController {
  
  class HitsViewController: UITableViewController, MultiIndexHitsController {
    
    var hitsSource: MultiIndexHitsSource?
    
    let actorsSection = 0
    let moviesSection = 1
    
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      guard let hitsSource = hitsSource else { return 0 }
      return hitsSource.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let hitsSource = hitsSource else { return .init() }
      return hitsSource.numberOfHits(inSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      guard let hitsSource = hitsSource else { return .init() }
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
      
      switch indexPath.section {
      case actorsSection:
        if let actor: Actor = try? hitsSource.hit(atIndex: indexPath.row, inSection: indexPath.section) {
          cell.textLabel?.text = actor.name
        }
        
      case moviesSection:
        if let movie: Movie = try? hitsSource.hit(atIndex: indexPath.row, inSection: indexPath.section)  {
          cell.textLabel?.text = movie.title
        }
        
      default:
        break
      }
      
      return cell
      
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      switch section {
      case actorsSection:
        return "Actors"
      case moviesSection:
        return "Movies"
      default:
        return nil
      }
    }
    
  }

}

