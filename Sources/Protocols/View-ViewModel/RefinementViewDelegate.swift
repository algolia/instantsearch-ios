//
//  RefinementViewDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 22/05/2017.
//
//

import Foundation

/// Protocol that defines the refinement view input methods and propreties.
@objc public protocol RefinementViewDelegate: AlgoliaIndexWidget {
    
    /// Attribute name of the control.
    var attribute: String { get set }
}
