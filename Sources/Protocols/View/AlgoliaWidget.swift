//
//  AlgoliaWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation

/// Marker protocol used to link the class (widget) with InstantSearch.
///
/// InstantSearch uses this protocol in 2 ways:
///
/// 1- To keep track of all widget objects in order to send them relevant
/// search events that are happening.
///
/// 2- To identify which widget views in the screen are linked to InstantSearch, 
/// and use that to automatically pickup and add all the widgets views to InstantSearch
///
/// - NOTE: It doesn't matter if an Algolia Widget is a View, a ViewController or a ViewModel.
/// Since InstantSearch is very protocol oriented, it doesn't really care about the nature of
/// the class (widget), whether it's the actual view on the screen or a controller wrapper class.
@objc public protocol AlgoliaWidget: class {}

/// This is an AlgoliaWidget that is used to link a widget to a specific index in the case of multi-indexing.
@objc public protocol AlgoliaIndexWidget: AlgoliaWidget {
    var index: String { get set }
    var variant: String { get set }
}

@objc public protocol AlgoliaMultiIndexWidget: AlgoliaWidget {
    var indicesArray: [String] { get set }
    var variantsArray: [String] { get set }
}
