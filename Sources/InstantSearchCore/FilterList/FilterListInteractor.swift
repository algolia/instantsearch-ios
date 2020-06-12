//
//  SelectableListInteractor+Filter.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 17/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias FilterListInteractor<F: FilterType & Hashable> = SelectableListInteractor<F, F>
