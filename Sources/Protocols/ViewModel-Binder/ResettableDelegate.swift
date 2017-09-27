//
//  ResultingDelegate.swift
//  InstantSearch
//
//  Created by Guy Daher on 05/04/2017.
//
//

import Foundation

/// Protocol that gives a callback when a reset/clear event is triggered.
@objc internal protocol ResettableDelegate: class {
    
    /// Callback on a reset/clear event.
    @objc func onReset()
}
