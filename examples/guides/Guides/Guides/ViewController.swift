//
//  ViewController.swift
//  Guides
//
//  Created by Vladislav Fitc on 31.03.2022.
//

import UIKit
import InstantSearch

class ViewController: UIViewController {
  
  let searchController: UISearchController
  let resultsViewController: GuideListTableViewController
  let searchConnector: SearchConnector<Guide>
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    resultsViewController = .init(style: .plain)
    searchController = .init(searchResultsController: resultsViewController)
    searchConnector = .init(appID: "latency",
                            apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                            indexName: "mobile_guides",
                            searchController: searchController,
                            hitsInteractor: .init(),
                            hitsController: resultsViewController)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Guides"
    view.backgroundColor = .white
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
    navigationItem.searchController = searchController
    searchConnector.hitsConnector.searcher.search()
    
    resultsViewController.didSelect = { [weak self] guide in
      self?.present(guide)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }
  
  func present(_ guide: Guide) {
    guard let guideViewController = GuideFactory.guideViewController(for: guide) else {
      let alertController = UIAlertController(title: "Error",
                                              message: "Guide not implemented yet",
                                              preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
      present(alertController, animated: true)
      return
    }
    navigationController?.pushViewController(guideViewController, animated: true)
  }

}

struct Guide: Codable {
  
  let objectID: String
  let name: String
  let type: String
  
}

class GuideFactory {
  
  enum GuideType: String {
    case voiceSearch = "guide_voice_search"
    case querySuggestions = "guide_query_suggestion"
    case insights = "guide_insights"
    case gettingStarted = "guide_getting_started"
    case declarativeUI = "guide_declarative_ui"
  }
  
  static func guideViewController(for guide: Guide) -> UIViewController? {
    guard let guideType = GuideType(rawValue: guide.objectID) else { return .none }
    switch guideType {
    case .voiceSearch:
      return VoiceInputDemoViewController()
    case .querySuggestions:
      return QuerySuggestionsDemoViewController()
    case .insights:
      return UIViewController()
    case .gettingStarted:
      return GettingStartedGuide.StepSeven.ViewController()
    case .declarativeUI:
      return SwiftUIDemoViewController()
    }
  }
  
}


class GuideListTableViewController: UITableViewController, HitsController {
  
  var hitsSource: HitsInteractor<Guide>?
  
  private let cellID = "cellID"
  
  var didSelect: ((Guide) -> Void)?
  
  override init(style: UITableView.Style) {
    super.init(style: style)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) else { return .init() }
    var content = cell.defaultContentConfiguration()
    content.text = hitsSource?.hit(atIndex: indexPath.row)?.name
    cell.contentConfiguration = content
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let guide = hitsSource?.hit(atIndex: indexPath.row) {
      didSelect?(guide)
    }
  }
  
  
}
