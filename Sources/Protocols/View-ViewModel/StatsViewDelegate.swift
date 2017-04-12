//
//  StatsViewDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 10/04/2017.
//
//

import Foundation

/*
 * Protocol that defines the view input methods and propreties
 */
@objc public protocol StatsViewDelegate: class {
    
    var viewModel: StatsViewModelDelegate! { get set }
    
    func set(text: String)
    
    var resultTemplate: String { get set }
    var errorText: String { get set }
    var clearText: String { get set }
}
