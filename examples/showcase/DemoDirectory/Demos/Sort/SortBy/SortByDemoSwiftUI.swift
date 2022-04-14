//
//  SortByDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 04/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct SortByDemoSwiftUI: PreviewProvider {
  
  class Controller {
    
    let demoController: SortByDemoController
    let queryInputController: QueryInputObservableController
    let selectableSegmentObservableController: SelectableSegmentObservableController
    let hitsController: HitsObservableController<Hit<StoreItem>>
    
    init() {
      demoController = SortByDemoController()
      queryInputController = QueryInputObservableController()
      selectableSegmentObservableController = SelectableSegmentObservableController()
      hitsController = HitsObservableController<Hit<StoreItem>>()
      
      demoController.queryInputConnector.connectController(queryInputController)
      demoController.hitsConnector.connectController(hitsController)
      demoController.sortByConnector.connectController(selectableSegmentObservableController,
                                                       presenter: demoController.title(for:))
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var queryInputController: QueryInputObservableController
    @ObservedObject var selectableSegmentObservableController: SelectableSegmentObservableController
    @ObservedObject var hitsController: HitsObservableController<Hit<StoreItem>>
        
    var body: some View {
      let selectedBinding = Binding(
        get: { self.selectableSegmentObservableController.selectedSegmentIndex ?? 0 },
        set: { self.selectableSegmentObservableController.select($0) }
      )
      VStack {
        Picker("Filter Segment", selection: selectedBinding) {
          ForEach(0 ..< selectableSegmentObservableController.segmentsTitles.count, id: \.self) { index in
            let title = selectableSegmentObservableController.segmentsTitles[index]
            Button(title) {
              selectableSegmentObservableController.select(index)
            }
          }
         }
         .pickerStyle(.segmented)
        HitsList(hitsController) { hit, index in
          ShopItemRow(product: hit)
        }
      }
      .padding()
      .searchable(text: $queryInputController.query)
    }

  }
  
  class ViewController: UIHostingController<ContentView> {
    
    let controller: Controller
    
    init() {
      controller = Controller()
      let rootView = ContentView(queryInputController: controller.queryInputController,
                                 selectableSegmentObservableController: controller.selectableSegmentObservableController,
                                 hitsController: controller.hitsController)
      super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }

  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return NavigationView {
      ContentView(queryInputController: controller.queryInputController,
                  selectableSegmentObservableController: controller.selectableSegmentObservableController,
                  hitsController: controller.hitsController)
      .navigationBarTitle("Sort By")
    }

  }
  
}
