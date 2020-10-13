//
//  QueryRuleCustomDataSnippets.swift
//  
//
//  Created by Vladislav Fitc on 13/10/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit)
import UIKit

class QueryRuleCustomDataSnippets {
  
  struct Banner: Decodable {
    let bannerURL: URL
  }
  
  class BannerViewController: UIViewController, ItemController {
    
    let bannerView: UIImageView = .init()
    
    override func viewDidLoad() {
      super.viewDidLoad()
      // some layout code
    }
    
    func setItem(_ item: Banner?) {
      guard let bannerURL = item?.bannerURL else {
        bannerView.image = nil
        return
      }
      URLSession.shared.dataTask(with: bannerURL) { (data, _, _) in
        self.bannerView.image = data.flatMap(UIImage.init)
      }.resume()
    }
    
  }
    
  func widgetExample() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    let bannerViewController = BannerViewController()
    let queryRuleCustomDataConnector = QueryRuleCustomDataConnector<Banner>(searcher: searcher,
                                                                            controller: bannerViewController)

    searcher.search()
    
    _ = queryRuleCustomDataConnector
    
  }
  
  func advancedExample() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourSearchOnlyAPIKey",
                                              indexName: "YourIndexName")
    let queryRuleCustomDataInteractor: QueryRuleCustomDataInteractor<Banner> = .init()
    let bannerViewController: BannerViewController = .init()

    queryRuleCustomDataInteractor.connectSearcher(searcher)
    queryRuleCustomDataInteractor.connectController(bannerViewController)
  }
  
}
#endif
