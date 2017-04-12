//
//  HitsViewDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation

/*
 * Protocol that defines the view input methods and propreties
 */
@objc public protocol HitsViewDelegate: class {

    var viewModel: HitsViewModelDelegate! { get set }
    
    func reloadHits()
    func scrollTop()
    
    var hitsPerPage: UInt { get set }
    var infiniteScrolling: Bool { get set }
    var remainingItemsBeforeLoading: UInt { get set }
}
