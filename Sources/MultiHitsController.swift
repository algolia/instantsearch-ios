//
//  MultiHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 22/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public protocol MultiHitsDataSource: class {
  
  func numberOfSections() -> Int
  func numberOfRows(inSection: Int) -> Int
  func hitsViewModel<R>(atIndex index: Int) throws -> HitsViewModel<R>
  
}

extension MultiHitsViewModel: MultiHitsDataSource {}

public protocol MultiHitsWidget: class {
  
  associatedtype SingleHitView
  
  var viewModel: MultiHitsViewModel? { get set }
  
  func reload()
  
  func scrollToTop()
  
}

public class MultiHitsController<HitsWidget: MultiHitsWidget>: NSObject {
  
  public let searcher: MultiIndexSearcher
  public let viewModel: MultiHitsViewModel
  public weak var widget: HitsWidget?
  public var errorHandler: ((Error) -> Void)?

  public init(client: Client, indexSearchDatas: [IndexSearchData], widget: HitsWidget, viewModel: MultiHitsViewModel = MultiHitsViewModel()) {
    self.searcher = MultiIndexSearcher(client: client, indexSearchDatas: indexSearchDatas)
    self.viewModel = viewModel
    self.widget = widget
    
    super.init()
    
    self.searcher.onSearchResults.subscribe(with: self) { [weak self] result in
      switch result {
      case .failure(let error):
        self?.errorHandler?(error)
        
      case .success(let results):
        do {
          try self?.viewModel.update(results)
        } catch let error {
          assertionFailure("\(error)")
        }
      }
    }
  }
  
}

extension Playground {
  
  func multihitsPlay() {
    
    let client = Client(appID: "app id", apiKey: "api key")
    
    let indexSearchDatas = [
      IndexSearchData(index: client.index(withName: "index1")),
      IndexSearchData(index: client.index(withName: "index2")),
      IndexSearchData(index: client.index(withName: "index3"))
    ]
    
    let tableView = UITableView()
    let widget = TableViewMultiHitsWidget(tableView: tableView)
    
    let dataSource = TableViewMultiHitsDataSource()
    
    dataSource.setCellConfigurator(forSection: 0) { (_: JSON) in return UITableViewCell() }
    dataSource.setCellConfigurator(forSection: 1) { (_: [String: Int]) in return UITableViewCell() }

    let delegate = TableViewMultiHitsDelegate()
    
    delegate.setClickHandler(forSection: 0) { (_: JSON) in print("click") }
    delegate.setClickHandler(forSection: 1) { (_: [String: Int]) in print("click") }
    
    let controller = MultiHitsController(client: client, indexSearchDatas: indexSearchDatas, widget: widget)
    
    controller.viewModel.insert(hitsViewModel: HitsViewModel<[String: Int]>(), atIndex: 0)
    controller.viewModel.insert(hitsViewModel: HitsViewModel<JSON>(), atIndex: 1)

  }
  
}
