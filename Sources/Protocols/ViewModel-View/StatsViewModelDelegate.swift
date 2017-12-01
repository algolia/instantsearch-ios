//
//  StatsViewModelDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 10/04/2017.
//
//

import Foundation

/*
 * Protocol that defines the commands sent from the View to the ViewModel
 */
@objc public protocol StatsViewModelDelegate: class {
    
    /// View associated with the WidgetVM.
    var view: StatsViewDelegate! { get set }
}
