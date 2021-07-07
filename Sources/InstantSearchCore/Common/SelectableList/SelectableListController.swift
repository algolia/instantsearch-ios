//
//  SelectableListController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 26/04/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol SelectableListController: AnyObject, Reloadable {

  associatedtype Item

  var onClick: ((Item) -> Void)? { get set }

  func setSelectableItems(selectableItems: [SelectableItem<Item>])

}
