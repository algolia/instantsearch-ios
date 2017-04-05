//
//  AlgoliaOutputWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 05/04/2017.
//
//

import Foundation

@objc public protocol AlgoliaResettableWidget: AlgoliaWidget {
    @objc func onReset()
}
