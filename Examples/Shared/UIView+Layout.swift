//
//  UIView+Layout.swift
//  Examples
//
//  Created by Vladislav Fitc on 04.04.2022.
//

import Foundation
import UIKit

extension UIView {

  func pin(to view: UIView, insets: UIEdgeInsets = .init()) {
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
      bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),
      leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
      trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right)
    ])
  }

  func pin(to layoutGuide: UILayoutGuide, insets: UIEdgeInsets = .init()) {
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top),
      bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: insets.bottom),
      leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: insets.left),
      trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: insets.right)
    ])
  }

  static var spacer: UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }

}
