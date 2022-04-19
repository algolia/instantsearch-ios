//
//  DemoViewControllerFactory.swift
//  Examples
//
//  Created by Vladislav Fitc on 05.04.2022.
//

import Foundation
import UIKit

class DemoViewControllerFactory: ViewControllerFactory {
  
  func viewController(for demo: Demo) -> UIViewController? {
    guard let id = Demo.ID(rawValue: demo.objectID.rawValue) else {
      return .none
    }
    
    switch id {
    case .codexQuerySuggestions:
      return QuerySuggestions.SearchViewController()
      
    case .codexVoiceSearch:
      return VoiceSearch.SearchViewController()
      
    case .codexMultipleIndex:
      return MultiIndex.SearchViewController()
      
    case .codexQuerySuggestionsCategories:
      return QuerySuggestionsCategories.SearchViewController()
      
    case .codexQuerySuggestionsRecent:
      return QuerySuggestionsAndRecentSearches.SearchViewController()
      
    case .codexQuerySuggestionsHits:
      return QuerySuggestionsAndHits.SearchViewController()
      
    case .codexCategoriesHits:
      return CategoriesHits.SearchViewController()
      
    case .guideInsights:
      return nil
      
    case .guideQuerySuggestion:
      return QuerySuggestionsDemoViewController()
      
    case .guideVoiceSearch:
      return VoiceInputDemoViewController()
      
    case .guideGettingStarted:
      return GettingStartedGuide.StepSeven.ViewController()
      
    case .guideDeclarativeUI:
      let controller = AlgoliaController()
      let rootView = ContentView(queryInputController: controller.queryInputController,
                                 hitsController: controller.hitsController,
                                 statsController: controller.statsController,
                                 facetListController: controller.facetListController)
      return CommonSwiftUIDemoViewController(controller: controller,
                                             rootView: rootView)
      
    case .showcaseImperative:
      let factory = ShowcaseDemoViewControllerFactory(framework: .uikit)
      let viewController = DemoListViewController<ShowcaseDemo>(indexName: "mobile_demo_home")
      let pusher = ViewControllerPusher(factory: factory,
                                        sourceViewController: viewController)
      viewController.didSelect = pusher.callAsFunction
      viewController.title = "Imperative UI"
      return viewController
      
    case .showCaseDeclarative:
      let factory = ShowcaseDemoViewControllerFactory(framework: .swiftui)
      let viewController = DemoListViewController<ShowcaseDemo>(indexName: "mobile_demo_home")
      let pusher = ViewControllerPusher(factory: factory,
                                        sourceViewController: viewController)
      viewController.didSelect = pusher.callAsFunction(_:)
      viewController.title = "Declarative UI"
      return viewController
    }
  }
  
}

