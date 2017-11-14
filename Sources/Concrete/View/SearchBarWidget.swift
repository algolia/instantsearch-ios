//
//  SearchBarWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

/// Widget that provides a user input for search queries that are directly sent to the Algolia engine. Built on top of `UISearchBar`.
@objc public class SearchBarWidget: UISearchBar, SearchViewDelegate, AlgoliaWidget, UISearchBarDelegate {
    
    @IBInspectable public var indexName: String = Constants.Defaults.indexName
    @IBInspectable public var indexId: String = Constants.Defaults.indexId
    
    var viewModel: SearchViewModelDelegate
    
    @objc public override init(frame: CGRect) {
        viewModel = SearchViewModel()
        super.init(frame: frame)
        viewModel.view = self
        delegate = self
    }
    
    @objc public required init?(coder aDecoder: NSCoder) {
        viewModel = SearchViewModel()
        super.init(coder: aDecoder)
        viewModel.view = self
        delegate = self
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.search(query: searchBar.text)
    }
    
    func set(text: String, andResignFirstResponder resignFirstResponder: Bool) {
        self.text = text
        if resignFirstResponder {
            self.resignFirstResponder()
        }
    }
}
