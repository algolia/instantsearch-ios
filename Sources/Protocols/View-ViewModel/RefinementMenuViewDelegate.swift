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
@objc internal protocol RefinementMenuViewDelegate: class {
    
    var viewModel: RefinementMenuViewModelDelegate! { get set }
    
    func reloadRefinements()
    
    var attribute: String { get set }
    var refinedFirst: Bool { get set }
    var sortBy: String { get set }
    var `operator`: String { get set }
    var limit: Int { get set }
}
