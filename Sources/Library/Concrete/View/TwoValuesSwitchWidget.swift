//
//  TwoValueSwitchWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 03/05/2017.
//
//

import Foundation

@objc public class TwoValuesSwitchWidget: SwitchWidget {
    override public func setup() {
        addTarget(viewModel, action: #selector(viewModel.numericFilterValueChanged), for: .valueChanged)
        // We add the initial value of the slider to the Search
        viewModel.numericFilterValueChanged()
    }
}
