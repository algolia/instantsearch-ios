//
//  ShowcaseDemoViewControllerFactory.swift
//  Examples
//
//  Created by Vladislav Fitc on 05.04.2022.
//

import Foundation
import UIKit

class ShowcaseDemoViewControllerFactory: ViewControllerFactory {
  
  enum Framework {
    case uikit
    case swiftui
  }
  
  let framework: Framework
  
  init(framework: Framework) {
    self.framework = framework
  }
  
  func viewController(for demo: ShowcaseDemo) -> UIViewController? {
    
    guard let demoID = ShowcaseDemo.ID(rawValue: demo.objectID.rawValue) else {
      return nil
    }
    
    let viewController: UIViewController?
    
    switch framework {
    case .uikit:
      viewController = uikitShowcaseViewController(for: demoID)
    case .swiftui:
      viewController = swiftuiShowcaseViewController(for: demoID)
    }
    
    viewController?.title = demo.name
    
    return viewController
  }
  
  func uikitShowcaseViewController(for demoID: ShowcaseDemo.ID) -> UIViewController? {
    let viewController: UIViewController
    
    switch demoID {
    case .singleIndex:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
      
    case .sffv:
      viewController = FacetSearchDemoViewController()
      
    case .toggle:
      viewController = ToggleDemoViewController()
      
    case .toggleDefault:
      viewController = ToggleDemoViewController()
      
    case .dynamicFacetList:
      viewController = DynamicFacetListDemoViewController()
      
    case .facetList:
      viewController = RefinementListDemoViewController()
      
    case .facetListPersistentSelection:
      viewController = RefinementListDemoViewController()
      
    case .segmented:
      viewController = SegmentedDemoViewController()
      
    case .filterNumericComparison:
      viewController = FilterNumericComparisonDemoViewController()
      
    case .filterNumericRange:
      viewController = FilterNumericRangeDemoViewController()
      
    case .filterRating:
      viewController = RatingViewController()
      
    case .sortBy:
      viewController = SortByDemoViewController()
      
    case .currentFilters:
      viewController = CurrentFiltersDemoViewController()
      
    case .clearFilters:
      viewController = ClearFiltersDemoViewController()
      
    case .relevantSort:
      viewController = RelevantSortDemoViewController()
      
    case .voiceSearch:
      viewController = VoiceInputDemoViewController()
      
    case .multiIndex:
      viewController = MultiIndexDemoViewController()
      
    case .facetFilterList:
      viewController = FilterListDemo.facet()
      
    case .numericFilterList:
      viewController = FilterListDemo.numeric()
      
    case .tagFilterList:
      viewController = FilterListDemo.tag()
      
    case .searchOnSubmit:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchOnSubmit)
      
    case .searchAsYouType:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
      
    case .stats:
      viewController = StatsDemoViewController()
      
    case .highlighting:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
      
    case .loading:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
      
    case .hierarchical:
      viewController = HierarchicalDemoViewController()
      
    case .querySuggestions:
      viewController = QuerySuggestionsDemoViewController()
      
    case .relatedItems:
      viewController = RelatedItemsDemoViewController()
      
    case .queryRuleCustomData:
      viewController = QueryRuleCustomDataDemoViewController()
      
    case .mergedList:
      viewController = QuerySuggestionsAndHits.SearchViewController()
    }
    
    return viewController
  }
  
  func swiftuiShowcaseViewController(for demoID: ShowcaseDemo.ID) -> UIViewController? {
    let viewController: UIViewController
    
    switch demoID {
    case .singleIndex:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
      
    case .sffv:
      viewController = FacetSearchDemoSwiftUI.ViewController()
      
    case .toggle:
      viewController = ToggleDemoViewController()
      
    case .toggleDefault:
      viewController = ToggleDemoViewController()
      
    case .dynamicFacetList:
      viewController = DynamicFacetDemoSwiftUI.ViewController()
      
    case .facetList:
      viewController = RefinementListDemoSwiftUI.ViewController()
      
    case .facetListPersistentSelection:
      viewController = RefinementListDemoSwiftUI.ViewController()
      
    case .segmented:
      viewController = SegmentedDemoViewController()
      
    case .filterNumericComparison:
      viewController = FilterNumericComparisonDemoViewController()
      
    case .filterNumericRange:
      viewController = FilterNumericRangeDemoViewController()
      
    case .filterRating:
      viewController = RatingViewController()
      
    case .sortBy:
      viewController = SortByDemoViewController()
      
    case .currentFilters:
      viewController = CurrentFiltersDemoViewController()
      
    case .clearFilters:
      viewController = ClearFiltersDemoViewController()
      
    case .relevantSort:
      viewController = RelevantSortDemoViewController()
      
    case .voiceSearch:
      viewController = VoiceInputDemoViewController()
      
    case .multiIndex:
      viewController = MultiIndexDemoViewController()
      
    case .facetFilterList:
      viewController = FilterListDemoSwiftUI.facetViewController()
      
    case .numericFilterList:
      viewController = FilterListDemoSwiftUI.numericViewController()
      
    case .tagFilterList:
      viewController = FilterListDemoSwiftUI.tagViewController()
      
    case .searchOnSubmit:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchOnSubmit)
      
    case .searchAsYouType:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
      
    case .stats:
      viewController = StatsDemoViewController()
      
    case .highlighting:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
      
    case .loading:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
      
    case .hierarchical:
      viewController = HierarchicalDemoSwiftUI.ViewController()
      
    case .querySuggestions:
      viewController = QuerySuggestionsDemoViewController()
      
    case .relatedItems:
      viewController = RelatedItemsDemoViewController()
      
    case .queryRuleCustomData:
      viewController = QueryRuleCustomDataDemoViewController()
      
    case .mergedList:
      viewController = QuerySuggestionsAndHits.SearchViewController()
    }
    
    return viewController
  }
  
}
