//
//  TextFieldWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

/// Widget that provides a user input for search queries that are directly sent to the Algolia engine. Built on top of `UITextField`.
@objcMembers public class TextFieldWidget: UITextField, SearchControlViewDelegate, AlgoliaWidget, UITextFieldDelegate {
    
    @IBInspectable public var index: String = Constants.Defaults.index
    @IBInspectable public var variant: String = Constants.Defaults.variant
    
    public var viewModel: SearchControlViewModelDelegate
    
    @objc public override init(frame: CGRect) {
        viewModel = SearchViewModel()
        super.init(frame: frame)
        viewModel.view = self
        delegate = self
        addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        viewModel = SearchViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
        delegate = self
        addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        guard let searchText = textField.text else { return }
        
        viewModel.search(query: searchText)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        
        viewModel.search(query: searchText)
    }
    
    public func set(text: String, andResignFirstResponder resignFirstResponder: Bool) {
        self.text = text
        if resignFirstResponder {
            self.resignFirstResponder()
        }
    }
}
