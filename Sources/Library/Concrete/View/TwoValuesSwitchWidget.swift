//
//  TwoValueSwitchWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 03/05/2017.
//
//

import Foundation

@objc public class TwoValuesSwitchWidget: SwitchWidget {
    @IBInspectable public var valueOff: String = Constants.Defaults.valueOff
    
    override public func configureView() {
        addTarget(self, action: #selector(facetValueChanged), for: .valueChanged)
        if isOn {
            viewModel.updatefacet(oldValue: valueOff, newValue: valueOn, doSearch: false)
        } else {
            viewModel.updatefacet(oldValue: valueOn, newValue: valueOff, doSearch: false)
        }
    }
    
    @objc private func facetValueChanged() {
        if isOn {
            viewModel.updatefacet(oldValue: valueOff, newValue: valueOn, doSearch: true)
        } else {
            viewModel.updatefacet(oldValue: valueOn, newValue: valueOff, doSearch: true)
        }
    }
    
    public override func set(value: String) {
        if value == valueOn {
            setOn(true, animated: true)
        } else if value == valueOff {
            setOn(false, animated: true)
        }
        
    }
}
