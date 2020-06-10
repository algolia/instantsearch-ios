//
//  SelectableController.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 03/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol SelectableController: ItemController {

  var onClick: ((Bool) -> Void)? { get set }

  func setSelected(_ isSelected: Bool)

}
