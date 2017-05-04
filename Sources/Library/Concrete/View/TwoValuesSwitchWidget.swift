//
//  TwoValueSwitchWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 03/05/2017.
//
//

import Foundation

@objc public class TwoValuesSwitchWidget: SwitchWidget {
    @IBInspectable public var valueOff: String = "false"
    
    override public func setup() {
        addTarget(self, action: #selector(facetValueChanged), for: .valueChanged)
        facetValueChanged()
    }
    
    @objc private func facetValueChanged() {
        if isOn {
            viewModel.updatefacet(oldValue: valueOff, newValue: valueOn)
        } else {
            viewModel.updatefacet(oldValue: valueOn, newValue: valueOff)
        }
    }
    
    // TODO: Make sure we still need this
    override public func getValue() -> String {
        return isOn ? valueOn: valueOff
    }
    
    public override func set(value: String) {
        print(value)
        if value == valueOn {
            setOn(true, animated: true)
        } else if value == valueOff {
            setOn(false, animated: true)
        }
        
    }
}
