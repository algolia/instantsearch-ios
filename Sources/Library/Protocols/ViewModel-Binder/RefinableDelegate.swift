//
//  RefinementControlWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

/// Protocol that gives callbacks when search parameters are being altered in the `Searcher`.
@objc public protocol RefinableDelegate: class {
    
    /// The attribute name associated with the refinement widget.
    @objc var attribute: String { get }
    
    /// Callback when any Numeric refinement change.
    @objc optional func onRefinementChange(numericMap: [String: [NumericRefinement]]?)
    
    /// Callback when the specific attribute numeric refinement has been changed.
    @objc optional func onRefinementChange(numerics: [NumericRefinement])
    
    /// Callback when any Facet refinement change.
    @objc optional func onRefinementChange(facetMap: [String: [FacetRefinement]]?)
    
    /// Callback when the specific attribute facet refinement has been changed.
    @objc optional func onRefinementChange(facets: [FacetRefinement])
}
