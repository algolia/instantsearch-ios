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

  // swiftlint:disable function_body_length cyclomatic_complexity
  func uikitShowcaseViewController(for demoID: ShowcaseDemo.ID) -> UIViewController? {
    let viewController: UIViewController

    switch demoID {
    case .singleIndex:
      viewController = SearchDemoViewController()

    case .sffv:
      viewController = FacetSearchDemoViewController()

    case .toggle:
      viewController = ToggleFilterDemoViewController()

    case .dynamicFacetList:
      viewController = DynamicFacetListDemoViewController()

    case .facetList:
      viewController = FacetListDemoViewController()

    case .facetListPersistentSelection:
      viewController = FacetListPersistentDemoViewController()

    case .segmented:
      viewController = SegmentedFilterDemoViewController()

    case .filterNumericComparison:
      viewController = FilterNumericComparisonDemoViewController()

    case .filterNumericRange:
      viewController = FilterNumericRangeDemoViewController()

    case .filterRating:
      viewController = RatingFilterDemoViewController()

    case .sortBy:
      viewController = SortByDemoViewController()

    case .currentFilters:
      viewController = CurrentFiltersDemoViewController()

    case .clearFilters:
      viewController = ClearFiltersDemoViewController()

    case .relevantSort:
      viewController = RelevantSortDemoViewController()

    case .multiIndex:
      viewController = MultiIndexDemoViewController()

    case .facetFilterList:
      viewController = FilterListDemo.facet()

    case .numericFilterList:
      viewController = FilterListDemo.numeric()

    case .tagFilterList:
      viewController = FilterListDemo.tag()

    case .searchOnSubmit:
      viewController = SearchDemoViewController(searchTriggeringMode: .searchOnSubmit)

    case .searchAsYouType:
      viewController = SearchDemoViewController()

    case .stats:
      viewController = StatsDemoViewController()

    case .highlighting:
      viewController = SearchDemoViewController()

    case .loading:
      viewController = SearchDemoViewController()

    case .hierarchical:
      viewController = HierarchicalDemoViewController()

    case .relatedItems:
      viewController = RelatedItemsDemoViewController()

    case .queryRuleCustomData:
      viewController = QueryRuleCustomDataDemoViewController()
    }

    return viewController
  }

  // swiftlint:disable function_body_length cyclomatic_complexity
  func swiftuiShowcaseViewController(for demoID: ShowcaseDemo.ID) -> UIViewController? {
    let viewController: UIViewController

    switch demoID {
    case .singleIndex:
      viewController = SearchDemoSwiftUI.viewController()

    case .sffv:
      viewController = FacetSearchDemoSwiftUI.viewController()

    case .toggle:
      viewController = ToggleFilterDemoSwiftUI.viewController()

    case .dynamicFacetList:
      viewController = DynamicFacetDemoSwiftUI.viewController()

    case .facetList:
      viewController = FacetListDemoSwiftUI.viewController()

    case .facetListPersistentSelection:
      viewController = FacetListPersistentDemoSwiftUI.viewController()

    case .segmented:
      viewController = SegmentedDemoSwiftUI.viewController()

    case .filterNumericComparison:
      viewController = FilterNumericComparisonDemoSwiftUI.viewController()

    case .filterNumericRange:
      viewController = FilterNumericRangeDemoSwiftUI.viewController()

    case .filterRating:
      viewController = RatingFilterDemoSwiftUI.viewController()

    case .sortBy:
      viewController = SortByDemoSwiftUI.viewController()

    case .currentFilters:
      viewController = CurrentFiltersDemoSwiftUI.viewController()

    case .clearFilters:
      viewController = ClearFiltersDemoSwiftUI.viewController()

    case .relevantSort:
      viewController = RelevantSortDemoSwiftUI.viewController()

    case .multiIndex:
      viewController = MultiIndexDemoSwiftUI.viewController()

    case .facetFilterList:
      viewController = FilterListDemoSwiftUI.facetViewController()

    case .numericFilterList:
      viewController = FilterListDemoSwiftUI.numericViewController()

    case .tagFilterList:
      viewController = FilterListDemoSwiftUI.tagViewController()

    case .searchOnSubmit:
      viewController = SearchDemoSwiftUI.viewController(searchTriggeringMode: .searchOnSubmit)

    case .searchAsYouType:
      viewController = SearchDemoSwiftUI.viewController()

    case .stats:
      viewController = StatsDemoSwiftUI.viewController()

    case .highlighting:
      viewController = SearchDemoSwiftUI.viewController()

    case .loading:
      viewController = SearchDemoSwiftUI.viewController()

    case .hierarchical:
      viewController = HierarchicalDemoSwiftUI.viewController()

    case .relatedItems:
      viewController = RelatedItemsDemoViewController()

    case .queryRuleCustomData:
      viewController = QueryRuleCustomDataSwiftUI.viewController()
    }

    return viewController
  }

}
