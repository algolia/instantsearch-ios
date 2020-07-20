//
//  FilterGroupsConvertible.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 18/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol FilterGroupsConvertible {

  func toFilterGroups() -> [FilterGroupType]

}
