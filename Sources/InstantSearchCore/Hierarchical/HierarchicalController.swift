//
//  HierarchicalController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 08/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol HierarchicalController: ItemController {

  var onClick: ((String) -> Void)? { get set }

}
