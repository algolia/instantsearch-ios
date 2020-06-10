//
//  StatsController.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 23/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol ItemTextController: ItemController where Item == String? {}

public protocol ItemAttributedTextController: ItemController where Item == NSAttributedString? {}

public typealias StatsTextController = ItemTextController
