//
//  ViewModelFetcher.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation
import InstantSearchCore

/// Fetches the ViewModel related to the specific Widget View.
class ViewModelFetcher {
    
    internal func tryFetchWidgetVM(with widgetV: AlgoliaWidget) -> Any? {
        switch widgetV {
        case let widgetV as HitsViewDelegate:
            return widgetV.viewModel
        case let widgetV as MultiHitsViewDelegate:
            return widgetV.viewModel
        case let widgetV as StatsViewDelegate:
            return widgetV.viewModel
        case let widgetV as RefinementMenuViewDelegate:
            return widgetV.viewModel
        case let widgetV as NumericControlViewDelegate:
            return widgetV.viewModel
        case let widgetV as FacetControlViewDelegate:
            return widgetV.viewModel
        case let widgetV as SearchControlViewDelegate:
            return widgetV.viewModel
        default: return nil
        }
    }
}
