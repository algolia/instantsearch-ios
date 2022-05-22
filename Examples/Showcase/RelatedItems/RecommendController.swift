//
//  RecommendController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 24/03/2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation
import UIKit
import AlgoliaSearchClient

class RecommendController {

  let recommendClient: RecommendClient

  init(recommendClient: RecommendClient) {
    self.recommendClient = recommendClient
  }

  func presentRelatedItems(for objectID: ObjectID, from sourceViewController: UIViewController, animated: Bool = true) {
    recommendClient.getRelatedProducts(options: [.init(indexName: .ecommerceRecommend, objectID: objectID)]) { result in
      DispatchQueue.main.async {
        switch result {
        case .failure(let error):
          let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
          sourceViewController.present(alertController, animated: animated)
        case .success(let response):
          let viewController = StoreItemsTableViewController.with(response.results.first!)
          viewController.title = "Related items"
          let navigationController = UINavigationController(rootViewController: viewController)
          sourceViewController.present(navigationController, animated: animated)
        }
      }
    }

  }

}
