//
//  ActivityIndicatorController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 24/05/2019.
//

import Foundation
import UIKit

public class ActivityIndicatorController: LoadableController {
  
  let activityIndicator: UIActivityIndicatorView
  
  public init (activityIndicator: UIActivityIndicatorView) {
    self.activityIndicator = activityIndicator
  }
  
  public func startAnimating() {
    activityIndicator.startAnimating()
  }
  
  public func stopAnimating() {
    activityIndicator.stopAnimating()
  }
  
}
