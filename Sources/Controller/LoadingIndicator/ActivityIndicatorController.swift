//
//  ActivityIndicatorController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 24/05/2019.
//

import Foundation
import InstantSearchCore
import UIKit

public class ActivityIndicatorController: LoadingController {
  public func setItem(_ item: Bool) {
    if item {
      activityIndicator.startAnimating()
    } else {
      activityIndicator.stopAnimating()
    }
  }

  let activityIndicator: UIActivityIndicatorView
  
  public init (activityIndicator: UIActivityIndicatorView) {
    self.activityIndicator = activityIndicator
  }
}
