//
//  TwoValueSwitchWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 03/05/2017.
//
//

import Foundation

/// Widget that controls the facet value of attribute. Built on top of `UISwitch`.
/// + Note: Use this for boolean values. (Example: "Sale" and "no sale")
/// + Remark: You must assign a value to the `attribute` property since the refinement table cannot operate without one. 
/// A FatalError will be thrown if you don't specify anything.
@objcMembers public class TwoValuesSwitchWidget: SwitchWidget {
    
    /// Value used for facet when the Switch is off
    @IBInspectable public var valueOff: String = Constants.Defaults.valueOff
    
    override public func configureView() {
        addTarget(self, action: #selector(facetValueChanged), for: .valueChanged)
        if isOn {
            viewModel.updateFacet(oldValue: valueOff, newValue: valueOn, doSearch: false)
        } else {
            viewModel.updateFacet(oldValue: valueOn, newValue: valueOff, doSearch: false)
        }
    }
    
    @objc private func facetValueChanged() {
        if isOn {
            viewModel.updateFacet(oldValue: valueOff, newValue: valueOn, doSearch: true)
        } else {
            viewModel.updateFacet(oldValue: valueOn, newValue: valueOff, doSearch: true)
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
