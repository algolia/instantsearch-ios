//
//  SegmentedControlWidget.swift
//  InstantSearch
//
//  Created by Guy Daher on 05/05/2017.
//
//

import Foundation
import UIKit

/// Widget that controls the facet value of attribute. Built on top of `UISegmentedControl`.
/// + Note: Use this for multiple facet values.
/// + Remark: You must assign a value to the `attribute` property since the refinement table cannot operate without one. 
/// A FatalError will be thrown if you don't specify anything.
@objcMembers public class SegmentedControlWidget: UISegmentedControl, FacetControlViewDelegate, AlgoliaWidget {
    
    private var oldSegmentedIndex: Int = UISegmentedControlNoSegment
    private var actualSegmentedIndex: Int = UISegmentedControlNoSegment
    
    @IBInspectable public var attribute: String = Constants.Defaults.attribute
    @IBInspectable public var inclusive: Bool = Constants.Defaults.inclusive
    
    @IBInspectable public var index: String = Constants.Defaults.index
    @IBInspectable public var variant: String = Constants.Defaults.variant
        
    public var viewModel: FacetControlViewModelDelegate
    
    public override init(items: [Any]?) {
        viewModel = FacetControlViewModel()
        super.init(items: items)
        viewModel.view = self
        actualSegmentedIndex = self.selectedSegmentIndex
    }
    
    public override init(frame: CGRect) {
        viewModel = FacetControlViewModel()
        super.init(frame: frame)
        viewModel.view = self
        actualSegmentedIndex = self.selectedSegmentIndex
    }
    
    public required init?(coder aDecoder: NSCoder) {
        viewModel = FacetControlViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
        actualSegmentedIndex = self.selectedSegmentIndex
    }
    
    open func set(value: String) {
        for index in 0..<numberOfSegments {
            if value == titleForSegment(at: index) {
                self.selectedSegmentIndex = index
                self.oldSegmentedIndex = self.actualSegmentedIndex
                self.actualSegmentedIndex = self.selectedSegmentIndex
                return
            }
        }
    }
    
    open func configureView() {
        addTarget(self, action: #selector(facetValueChanged), for: .valueChanged)
        if selectedSegmentIndex != UISegmentedControlNoSegment {
            viewModel.addFacet(value: titleForSegment(at: self.actualSegmentedIndex)!, doSearch: false)
        }
    }
    
    @objc private func facetValueChanged() {
        guard self.selectedSegmentIndex != UISegmentedControlNoSegment else { return }
        
        self.oldSegmentedIndex = self.actualSegmentedIndex
        self.actualSegmentedIndex = self.selectedSegmentIndex
        
        if self.oldSegmentedIndex == UISegmentedControlNoSegment {
            viewModel.addFacet(value: titleForSegment(at: self.actualSegmentedIndex)!, doSearch: true)
        } else {
            viewModel.updateFacet(oldValue: titleForSegment(at: self.oldSegmentedIndex)!,
                                  newValue: titleForSegment(at: self.actualSegmentedIndex)!,
                                  doSearch: true)
        }
    }
}
