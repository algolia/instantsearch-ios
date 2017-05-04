//
//  FacetControlViewModelDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 04/05/2017.
//
//

import Foundation

/*
 * Protocol that defines the commands sent from the View to the ViewModel
 */
@objc internal protocol FacetControlViewModelDelegate: class {
    
    var view: FacetControlViewDelegate! { get set }
    
    func addFacet(value: String)
    func updatefacet(oldValue:String, newValue: String)
    func removeFacet(value: String)
}
