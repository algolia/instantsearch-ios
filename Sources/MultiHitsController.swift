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

public protocol MultiHitsSource: class {
    
  func numberOfSections() -> Int
  func numberOfHits(inSection section: Int) -> Int
  func hitsViewModel<R>(forSection section: Int) throws -> HitsViewModel<R>
  
}

extension MultiHitsViewModel: MultiHitsSource {

}

public protocol MultiHitsWidget: class {
  
  associatedtype SingleHitView
  
  var viewModel: MultiHitsViewModel? { get set }
  
  func reload()
  
  func scrollToTop()
  
}

public class MultiHitsController<HitsWidget: MultiHitsWidget>: NSObject {
  
  private(set) var searcher: MultiIndexSearcher
  public let viewModel: MultiHitsViewModel
  public weak var widget: HitsWidget?
  public var errorHandler: ((Error) -> Void)?

  public init(client: Client, widget: HitsWidget, viewModel: MultiHitsViewModel = MultiHitsViewModel()) {
    self.searcher = MultiIndexSearcher(client: client, indexSearchDatas: [])
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
      self?.widget?.reload()
    }.onQueue(.main)
    
    self.widget?.viewModel = viewModel
    
  }
  
  public func register<Record: Codable>(_ indexSearchData: IndexSearchData, with recordType: Record.Type) {
    let hitsViewModel = HitsViewModel<Record>()
    viewModel.append(hitsViewModel)
    searcher = MultiIndexSearcher(client: searcher.client, indexSearchDatas: searcher.indexSearchDatas + [indexSearchData])
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
    
    dataSource.setCellConfigurator(forSection: 0) { (_, _: JSON, _) in return UITableViewCell() }
    dataSource.setCellConfigurator(forSection: 1) { (_, _: [String: Int], _) in return UITableViewCell() }

    let delegate = TableViewMultiHitsDelegate()
    
    delegate.setClickHandler(forSection: 0) { (_, _: JSON, _) in print("click") }
    delegate.setClickHandler(forSection: 1) { (_, _: [String: Int], _) in print("click") }
    
    let controller = MultiHitsController(client: client, widget: widget)
    
    controller.viewModel.insert(hitsViewModel: HitsViewModel<[String: Int]>(), inSection: 0)
    controller.viewModel.insert(hitsViewModel: HitsViewModel<JSON>(), inSection: 1)

  }
  
}
