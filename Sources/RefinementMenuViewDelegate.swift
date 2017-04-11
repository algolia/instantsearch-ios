//
//  RefinementMenuViewDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation
import InstantSearchCore

/*
 * Protocol that defines the view input methods and propreties
 */
@objc public protocol RefinementMenuViewDelegate: class {
    
    var viewModel: RefinementMenuViewModelDelegate! { get set }
    
    func reloadRefinements()
    
    var facet: String { get set }
    var areRefinedValuesFirst: Bool { get set }
    var isDisjunctive: Bool { get set }
    var transformRefinementList: TransformRefinementList { get set }
}
