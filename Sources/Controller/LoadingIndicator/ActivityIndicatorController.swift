//
//  ActivityIndicatorController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 24/05/2019.
//

import Foundation
import InstantSearchCore
import UIKit

public class ActivityIndicatorController: LoadableController {
  
  let activityIndicator: UIActivityIndicatorView
  
  public init (activityIndicator: UIActivityIndicatorView) {
    self.activityIndicator = activityIndicator
  }
  
  public func startLoading() {
    activityIndicator.startAnimating()
  }
  
  public func stopLoading() {
    activityIndicator.stopAnimating()
  }
  
}
