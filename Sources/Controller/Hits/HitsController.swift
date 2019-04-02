//
//  HitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore

public typealias HitViewConfigurator<HitsView, SingleHitView, Hit> = (HitsView, Hit, IndexPath) -> SingleHitView
public typealias HitClickHandler<HitsView, Hit> = (HitsView, Hit, IndexPath) -> Void

public class HitsController<Widget: HitsWidget>: NSObject {
  
  public let searcher: SingleIndexSearcher<Widget.Hit>
  public let viewModel: HitsViewModel<Widget.Hit>
  public weak var widget: Widget?
  public let onError: Observer<Error>
    
  public init(searcher: SingleIndexSearcher<Widget.Hit>, viewModel: HitsViewModel<Widget.Hit>, widget: Widget) {
    self.searcher = searcher
    self.viewModel = viewModel
    self.widget = widget
    self.onError = Observer<Error>()
    self.widget?.viewModel = viewModel
  }
  
  public convenience init(index: Index, widget: Widget) {
    let query = Query()
    let filterBuilder = FilterBuilder()
    let searcher = SingleIndexSearcher<Widget.Hit>(index: index, query: query, filterBuilder: filterBuilder)

    let viewModel = HitsViewModel<Widget.Hit>()
    self.init(searcher: searcher, viewModel: viewModel, widget: widget)
  
    searcher.onSearchResults.subscribe(with: self) { [weak self] (arg) in
      let (metadata, result) = arg
      switch result {
      case .success(let searchResults):
        viewModel.update(searchResults, with: metadata)
        widget.reload()

      case .failure(let error):
        self?.onError.fire(error)
      }
    }.onQueue(.main)
    
    viewModel.onNewPage.subscribe(with: self) { [weak self] page in
      self?.searcher.indexSearchData.query.page = UInt(page)
      self?.searcher.search()
    }
    
  }
  
  public func searchWithQueryText(_ queryText: String) {
    searcher.setQuery(text: queryText)
    searcher.indexSearchData.query.page = 0
    searcher.search()
  }
  
}
