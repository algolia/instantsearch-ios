//
//  HitsViewModelDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation

/*
 * Protocol that defines the commands sent from the View to the ViewModel
 */
@objc public protocol HitsViewModelDelegate: class {
    
    /// View associated with the WidgetVM.
    var view: HitsViewDelegate! { get set }
    
    /// Query the number of Rows to show.
    func numberOfRows() -> Int
    
    /// Query the hit to show for a row at a specific indexPath.
    func hitForRow(at indexPath: IndexPath) -> [String: Any]
}
