//
//  CustomSlider.swift
//  Example
//
//  Created by Guy Daher on 18/04/2017.
//
//

import UIKit
import InstantSearchCore

/// Custom Algolia Widget that contains a Slider and a Label to represent the value of the Slider.
/// This widget demos how you can implement `RefinableDelegate` so that it reacts to change in a particular refinement
@objc public class CustomSlider: UIView {
    
    // MARK: - Initializers
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider! {
        didSet {
            slider.minimumValue = 0
            slider.maximumValue = 100
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Helper Methods
    
    // Performs the initial setup.
    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        // Show the view.
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
}

extension CustomSlider: AlgoliaWidget, RefinableDelegate {
    public var attribute: String {
        return "salePrice"
    }
    
    @objc public func onRefinementChange(numerics: [NumericRefinement]) {
        for numeric in numerics where numeric.op == .lessThan {
            
            slider.value = numeric.value.floatValue
            label.text = "\(numeric.value)"
        }
    }
}
