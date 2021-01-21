//
//  ActivityIndicatorController.swift
//  InstantSearch
//
//  Created by Vladislav Fitc on 24/05/2019.
//

#if !InstantSearchCocoaPods
import InstantSearchCore
#endif
#if canImport(UIKit) && (os(iOS) || os(tvOS) || os(macOS))
import UIKit

public class ActivityIndicatorController: LoadingController {

  public let activityIndicator: UIActivityIndicatorView

  public init (activityIndicator: UIActivityIndicatorView) {
    self.activityIndicator = activityIndicator
  }

  public func startLoading() {
    activityIndicator.startAnimating()
  }

  public func stopLoading() {
    activityIndicator.stopAnimating()
  }

  public func setItem(_ item: Bool) {
    item ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
  }

}
#endif
