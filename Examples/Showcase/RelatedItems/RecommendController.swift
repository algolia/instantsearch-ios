//
//  RecommendController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 24/03/2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation
import UIKit

#if canImport(Recommend)
import Recommend

class RecommendController {
  let recommendClient: RecommendClient

  init(recommendClient: RecommendClient) {
    self.recommendClient = recommendClient
  }

  func presentRelatedItems(for objectID: String, from sourceViewController: UIViewController, animated: Bool = true) {
    let request = RecommendationsRequest.relatedQuery(.init(indexName: .ecommerceRecommend,
                                                           threshold: 0,
                                                           model: .relatedProducts,
                                                           objectID: objectID))
    let params = GetRecommendationsParams(requests: [request])
    Task {
      do {
        let response = try await recommendClient.getRecommendations(getRecommendationsParams: params)
        DispatchQueue.main.async {
          let viewController = StoreItemsTableViewController.with(response.results.first!)
          viewController.title = "Related items"
          let navigationController = UINavigationController(rootViewController: viewController)
          sourceViewController.present(navigationController, animated: animated)
        }
      } catch {
        DispatchQueue.main.async {
          let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
          sourceViewController.present(alertController, animated: animated)
        }
      }
    }
  }
}
#endif
