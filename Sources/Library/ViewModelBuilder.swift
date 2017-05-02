//
//  Builder.swift
//  InstantSearch
//
//  Created by Guy Daher on 07/04/2017.
//
//

import Foundation
import InstantSearchCore

class ViewModelBuilder {
    
    internal func tryBuildWidgetVM(with widgetV: AlgoliaWidget) -> Any? {
        switch widgetV {
        case let hitWidgetV as HitsViewDelegate:
            return buildWidgetVM(with: hitWidgetV)
        case let hitWidgetV as StatsViewDelegate:
            return buildWidgetVM(with: hitWidgetV)
        case let hitWidgetV as RefinementMenuViewDelegate:
            return buildWidgetVM(with: hitWidgetV)
        case let hitWidgetV as RefinementControlViewDelegate:
            return buildWidgetVM(with: hitWidgetV)
        default: return nil
        }
    }
    
    private func buildWidgetVM(with hitView: HitsViewDelegate) -> Any? {
//        let hitsViewModel = HitsViewModel()
//        hitsViewModel.view = hitView
//        hitView.viewModel = hitsViewModel
        
        return hitView.viewModel
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
    
    private func buildWidgetVM(with refinementControlView: RefinementControlViewDelegate) -> RefinementControlViewModel {
        let refinementControlViewModel = RefinementControlViewModel()
        refinementControlViewModel.view = refinementControlView
        refinementControlView.viewModel = refinementControlViewModel
        
        return refinementControlViewModel
    }
}
