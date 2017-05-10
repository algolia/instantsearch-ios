//
//  File.swift
//  InstantSearch
//
//  Created by Guy Daher on 04/05/2017.
//
//

import Foundation

/*
 * Protocol that defines the view input methods and propreties
 */
@objc internal protocol FacetControlViewDelegate: class {
    var viewModel: FacetControlViewModelDelegate { get set }
    
    func configureView()
    func set(value: String)
    
    var inclusive: Bool { get set }
    var attributeName: String { get set }
}
