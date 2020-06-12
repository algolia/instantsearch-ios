//
//  FilterListController.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 17/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public protocol FilterListController: SelectableListController where Item: FilterType {}

public protocol FacetFilterListController: FilterListController where Item == Filter.Facet {}
public protocol NumericFilterListController: FilterListController where Item == Filter.Numeric {}
public protocol TagFilterListController: FilterListController where Item == Filter.Tag {}
