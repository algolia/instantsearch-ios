//
//  TestViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 12/10/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit

class TemplateViewController: UIViewController {

  let label = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    label.pin(to: view.safeAreaLayoutGuide)
  }

}
