//
//  BannerViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 12/10/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

class BannerViewController: UIViewController, ItemController {

  var banner: Banner? {
    didSet {
      guard let banner = banner else { return }
      if let imageURL = banner.banner {
        imageView.sd_setImage(with: imageURL)
      } else if let text = banner.title {
        label.text = text
        view.backgroundColor = UIColor(red: 84/255, green: 104/255, blue: 1, alpha: 1)
      }
    }
  }

  let imageView: UIImageView
  let label: UILabel
  var didTapBanner: (() -> Void)?

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    imageView = .init()
    label = .init()
    super.init(nibName: nil, bundle: nil)
    label.textColor = .systemBackground
    imageView.contentMode = .scaleAspectFit
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBanner(_:)))
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(tapGestureRecognizer)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(imageView)
    imageView.pin(to: view)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    view.addSubview(label)
    label.pin(to: view, insets: .init(top: 10, left: 10, bottom: -10, right: -10))
  }

  @objc func didTapBanner(_ tapGestureRecognizer: UITapGestureRecognizer) {
    didTapBanner?()
  }

  func setItem(_ item: Banner?) {
    banner = item
    if banner == nil {
      view.isHidden = true
      view.backgroundColor = .systemBackground
      imageView.sd_setImage(with: nil)
      label.text = nil
    } else {
      view.isHidden = false
    }
  }

}
