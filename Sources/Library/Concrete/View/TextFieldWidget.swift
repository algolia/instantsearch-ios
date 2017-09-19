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
@objc public class TextFieldWidget: UITextField, SearchableViewModel, ResettableDelegate, AlgoliaWidget, UITextFieldDelegate {
    
    public var searcher: Searcher!
    
    public func configure(with searcher: Searcher) {
        self.searcher = searcher
        delegate = self
        addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        guard let searchText = textField.text else { return }
        
        searcher.params.query = searchText
        searcher.search()
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        
        searcher.params.query = searchText
        searcher.search()
    }
    
    public func onReset() {
        resignFirstResponder()
        text = ""
    }
}
