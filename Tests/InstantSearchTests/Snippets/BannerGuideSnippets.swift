//
//  BannerGuideSnippets.swift
//
//
//  Created by Vladislav Fitc on 20/10/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && !os(watchOS)
  import UIKit

  class BannerGuideSnippets {
    struct Banner: Decodable {
      let title: String
    }

    class BannerViewController: UIViewController, ItemController {
      let titleLabel: UILabel = .init()

      override func viewDidLoad() {
        super.viewDidLoad()
        // some layout code
      }

      func setItem(_ item: Banner?) {
        titleLabel.text = item?.title
      }
    }

    func setupWidget() {
      let searcher: HitsSearcher = .init(appID: "YourApplicationID",
                                         apiKey: "YourSearchOnlyAPIKey",
                                         indexName: "YourIndexName")
      let bannerViewController = BannerViewController()
      let queryRuleCustomDataConnector = QueryRuleCustomDataConnector<Banner>(searcher: searcher,
                                                                              controller: bannerViewController)

      searcher.search()

      _ = queryRuleCustomDataConnector
    }
  }
#endif
