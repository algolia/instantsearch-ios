//
//  MultiHitsViewModelDelegate.swift
//  InstantSearch-iOS
//
//  Created by Guy Daher on 24/11/2017.
//

import Foundation

/*
 * Protocol that defines the commands sent from the View to the ViewModel
 */
@objc internal protocol MultiHitsViewModelDelegate: class {
    
    /// View associated with the WidgetVM.
    var view: MultiHitsViewDelegate! { get set }
    
    /// Query the number of Rows to show.
    func numberOfRows(in section: Int) -> Int
    
    /// Query the hit to show for a row at a specific indexPath.
    func hitForRow(at indexPath: IndexPath) -> [String: Any]
}
