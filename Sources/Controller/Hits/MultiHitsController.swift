//
//  MultiHitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 22/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore

public class MultiHitsController<HitsWidget: MultiHitsWidget>: NSObject {
  
  public let searcher: MultiIndexSearcher
  public let viewModel: MultiHitsViewModel
  public weak var widget: HitsWidget?
  public let onError: Observer<Error>

  public init(client: Client, widget: HitsWidget, viewModel: MultiHitsViewModel = MultiHitsViewModel()) {
    self.searcher = MultiIndexSearcher(client: client, indexSearchDatas: [])
    self.viewModel = viewModel
    self.widget = widget
    self.onError = Observer<Error>()
    super.init()
    
    self.searcher.onSearchResults.subscribe(with: self) { [weak self] result in
      switch result {
      case .failure(let error):
        self?.onError.fire(error)
        
      case .success(let results):
        do {
          try self?.viewModel.update(results)
        } catch let error {
          assertionFailure("\(error)")
        }
      }
      self?.widget?.reload()
    }.onQueue(.main)
    
    self.widget?.hitsSource = viewModel
    
  }
  
  public func register<Record: Codable>(_ indexSearchData: IndexSearchData, with recordType: Record.Type) {
    let hitsViewModel = HitsViewModel<Record>()
    viewModel.append(hitsViewModel)
    searcher.indexSearchDatas.append(indexSearchData)
  }
  
  public func searchWithQueryText(_ queryText: String) {
    searcher.setQuery(text: queryText)
    searcher.indexSearchDatas.forEach { $0.query.page = 0 }
    searcher.search()
  }
  
}
