//
//  RefinementControlViewModelDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 11/04/2017.
//
//

import Foundation

/*
 * Protocol that defines the commands sent from the View to the ViewModel
 */
@objc internal protocol RefinementControlViewModelDelegate: class {
    
    var view: RefinementControlViewDelegate! { get set }
    
    func numericFilterValueChanged()
    func removeNumericValue()
}
