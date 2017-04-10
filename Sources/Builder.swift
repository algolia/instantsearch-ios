//
//  Builder.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation
import InstantSearchCore

/// Handles the dependencies and binding between View - ViewModel, and ViewModel - Model
/// The Views are the widgets
/// the ViewModel are the business logic of the widgets
/// The Model is the Searcher.
class Builder {
    
    var searcher: Searcher
    
    init(searcher: Searcher) {
        self.searcher = searcher
    }
    
    func build(hitView: HitsViewDelegate) -> HitsViewModel {
        let hitsViewModel = HitsViewModel()
        hitsViewModel.view = hitView
        hitView.viewModel = hitsViewModel
        hitsViewModel.searcher = searcher
        
        return hitsViewModel
    }
}
