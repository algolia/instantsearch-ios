//
//  OneValueSwitchWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 03/05/2017.
//
//

import Foundation

@objc public class OneValueSwitchWidget: SwitchWidget {
    override public func configureView() {
        addTarget(self, action: #selector(facetValueChanged), for: .valueChanged)
    }
    
    @objc private func facetValueChanged() {
        if isOn {
            viewModel.addFacet(value: valueOn, doSearch: true)
        } else {
            viewModel.removeFacet(value: valueOn)
        }
    }
}
