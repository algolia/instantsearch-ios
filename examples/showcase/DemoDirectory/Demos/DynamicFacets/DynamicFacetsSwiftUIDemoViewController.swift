//
//  DynamicFacetListSwiftUIDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 16/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct DynamicFacetDemoSwiftUI: PreviewProvider {
  
  class Controller {
      
    let queryInputController: QueryInputObservableController
    let filterStateController: FilterStateObservableController
    let facetsController: DynamicFacetListObservableController
    let controller: DynamicFacetListDemoController
    
    init() {
      queryInputController = QueryInputObservableController()
      facetsController = DynamicFacetListObservableController()
      controller = DynamicFacetListDemoController(queryInputController: queryInputController,
                                                             dynamicFacetListController: facetsController)
      filterStateController = FilterStateObservableController(filterState: controller.filterState)
    }
  
  }
  
  struct ContentView: View {
    
    let queryInputController: QueryInputObservableController
    let facetsController: DynamicFacetListObservableController
    
    var body: some View {
      SearchDemoContainerView(queryInputController) {
        DynamicFacetList(dynamicFacetListController: facetsController)
          .navigationBarTitle("Dynamic facets")
      }
    }
    
  }
  
  class ViewController: UIHostingController<ContentView> {
    
    let controller: Controller
    
    init() {
      controller = Controller()
      let rootView = ContentView(queryInputController: controller.queryInputController,
                                 facetsController: controller.facetsController)
      super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }

  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return ContentView(queryInputController: controller.queryInputController,
                            facetsController: controller.facetsController)
  }
  
}
