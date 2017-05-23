//
//  ResultingDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 05/04/2017.
//
//

import Foundation

@objc public protocol ResettableDelegate: class {
    
    /// Callback on a reset/clear event.
    @objc func onReset()
}
