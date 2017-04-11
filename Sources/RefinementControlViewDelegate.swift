//
//  RefinementControlViewDelegate.swift
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
@objc public protocol RefinementControlViewDelegate: class {
    
    var viewModel: RefinementControlViewModelDelegate! { get set }
    
    func registerAction()
    func set(value: NSNumber)
    func getValue() -> NSNumber
    
    var clearValue: NSNumber { get set }
    var op: NumericRefinement.Operator { get set }
    var inclusive: Bool { get set }
    var attributeName: String { get set }

}
