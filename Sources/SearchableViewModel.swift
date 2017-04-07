//
//  SearchableViewModel.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

@objc public protocol SearchableViewModel: class {
    var searcher: Searcher! { get set }
}
