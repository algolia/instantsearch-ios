//
//  ViewModelFetcher.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation
import InstantSearchCore

class ViewModelFetcher {
    
    internal func tryFetchWidgetVM(with widgetV: AlgoliaWidget) -> Any? {
        switch widgetV {
        case let hitWidgetV as HitsViewDelegate:
            return hitWidgetV.viewModel
        case let hitWidgetV as StatsViewDelegate:
            return hitWidgetV.viewModel
        case let hitWidgetV as RefinementMenuViewDelegate:
            return hitWidgetV.viewModel
        case let hitWidgetV as NumericControlViewDelegate:
            return hitWidgetV.viewModel
        case let hitWidgetV as FacetControlViewDelegate:
            return hitWidgetV.viewModel
        default: return nil
        }
    }
}
