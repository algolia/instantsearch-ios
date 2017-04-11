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
class ViewModelBuilder {
    
    internal func tryBuildWidgetVM(with widgetV: AlgoliaView) -> Any? {
        switch widgetV {
        case let hitWidgetV as HitsViewDelegate:
            return buildWidgetVM(with: hitWidgetV)
        case let hitWidgetV as StatsViewDelegate:
            return buildWidgetVM(with: hitWidgetV)
        case let hitWidgetV as RefinementMenuViewDelegate:
            return buildWidgetVM(with: hitWidgetV)
        default: return nil
        }
    }
    
    private func buildWidgetVM(with hitView: HitsViewDelegate) -> HitsViewModel {
        let hitsViewModel = HitsViewModel()
        hitsViewModel.view = hitView
        hitView.viewModel = hitsViewModel
        
        return hitsViewModel
    }
    
    private func buildWidgetVM(with statView: StatsViewDelegate) -> StatsViewModel {
        let statsViewModel = StatsViewModel()
        statsViewModel.view = statView
        statView.viewModel = statsViewModel
        
        return statsViewModel
    }
    
    private func buildWidgetVM(with refinementMenuView: RefinementMenuViewDelegate) -> RefinementMenuViewModel {
        let refinementMenuViewModel = RefinementMenuViewModel()
        refinementMenuViewModel.view = refinementMenuView
        refinementMenuView.viewModel = refinementMenuViewModel
        
        return refinementMenuViewModel
    }
}
