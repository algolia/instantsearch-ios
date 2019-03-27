//
//  HitsController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 21/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

public typealias HitViewConfigurator<Hit, HitView> = (Hit) -> HitView
public typealias HitClickHandler<Hit> = (Hit) -> Void

public protocol HitsDataSource: class {
  
  associatedtype Hit: Codable
  
  func numberOfRows() -> Int
  func hitForRow(atIndex rowIndex: Int) -> Hit?
  
}

extension InstantSearchCore.HitsViewModel: HitsDataSource {}

public protocol HitsWidget: class {
  
  associatedtype SingleHitView
  associatedtype Hit: Codable
  
  var viewModel: HitsViewModel<Hit>? { get set }
  
  func reload()
  
  func scrollToTop()
  
}

public class HitsController<Widget: HitsWidget>: NSObject {
  
  public let searcher: SingleIndexSearcher<Widget.Hit>
  public let viewModel: HitsViewModel<Widget.Hit>
  public weak var widget: Widget?
  public var errorHandler: ((Error) -> Void)?
    
  public init(searcher: SingleIndexSearcher<Widget.Hit>, viewModel: HitsViewModel<Widget.Hit>, widget: Widget) {
    self.searcher = searcher
    self.viewModel = viewModel
    self.widget = widget
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
        self?.errorHandler?(error)
      }
    }
    
  }
  
}

struct Playground {
  
  func play() {
    
    let tableView = UITableView()
    
    let widget = TableViewHitsWidget<JSON>(tableView: tableView)
    
    widget.dataSource = TableViewHitsDataSource { hit -> UITableViewCell in
      let cell = tableView.dequeueReusableCell(withIdentifier: "id")!
      cell.textLabel?.text = [String: Any](hit)?["name"] as? String
      return cell
    }

    widget.delegate = TableViewHitsDelegate { hit in
      let name = [String: Any](hit)!["name"] as! String
      print("Name: \(name)")
    }
    
    let index = Client(appID: "appID", apiKey: "apiKey").index(withName: "index")
    _ = HitsController(index: index, widget: widget)
    
  }
  
}
