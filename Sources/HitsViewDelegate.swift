//
//  HitsViewDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation

/*
 * Protocol that defines the view input methods.
 */
@objc public protocol HitsViewDelegate: class {
    
    func reloadHits()
    func scrollTop()
    
    var hitsPerPage: UInt { get set }
    var infiniteScrolling: Bool { get set }
    var remainingItemsBeforeLoading: UInt { get set }
    
    var viewModel: HitsViewModelDelegate! { get set }
}
