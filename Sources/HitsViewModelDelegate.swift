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
@objc public protocol HitsViewModelDelegate: SearchableViewModel {
    
    var view: HitsViewDelegate! { get set }
    
    func numberOfRows() -> Int
    func hitForRow(at indexPath: IndexPath) -> [String: Any]
}
