//
//  RelevantSortDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct RelevantSortDemoSwiftUI : PreviewProvider {
  
  struct ContentView: View {
    
    @ObservedObject var queryInputController: QueryInputObservableController
    @ObservedObject var sortByController: SelectableSegmentObservableController
    @ObservedObject var relevantSortController: RelevantSortObservableController
    @ObservedObject var hitsController: HitsObservableController<RelevantSortDemoController.Item>
    @ObservedObject var statsController: StatsTextObservableController
    
    @State var isEditing: Bool = false
        
    var body: some View {
      VStack {
        SearchBar(text: $queryInputController.query,
                  isEditing: $isEditing)
          .padding(.all, 5)
        if #available(iOS 14.0, *) {
          Menu {
            ForEach(0 ..< sortByController.segmentsTitles.count, id: \.self) { index in
              let indexName = sortByController.segmentsTitles[index]
              Button(indexName) {
                sortByController.select(index)
              }
            }
          } label: {
            if let selectedSegmentIndex = sortByController.selectedSegmentIndex {
              Label(sortByController.segmentsTitles[selectedSegmentIndex], systemImage: "arrow.up.arrow.down.circle")
            }
          }
        }
        Text(statsController.stats)
        if let state = relevantSortController.state {
          HStack {
            Text(state.hintText)
              .foregroundColor(.gray)
              .font(.footnote)
            Spacer()
            Button(state.toggleTitle,
                   action: relevantSortController.toggle)
          }.padding(.all, 5)
        }
        HitsList(hitsController) { hit, index in
          VStack {
            HStack {
              Text(hit?.name ?? "")
              Spacer()
            }
            Divider()
          }
          .padding(.horizontal, 5)
        }
      }
    }

  }
  
  static let relevantSortController = RelevantSortObservableController()
  static let sortByController = SelectableSegmentObservableController()
  static let hitsController = HitsObservableController<RelevantSortDemoController.Item>()
  static let queryInputController = QueryInputObservableController()
  static let statsController = StatsTextObservableController()
  
  static let demoController = RelevantSortDemoController(sortByController: sortByController,
                                                         relevantSortController: relevantSortController,
                                                         hitsController: hitsController,
                                                         queryInputController: queryInputController,
                                                         statsController: statsController)
  
  static var previews: some View {
    let _ = (demoController,
             relevantSortController,
             sortByController,
             queryInputController)
    ContentView(queryInputController: queryInputController,
                sortByController: sortByController,
                relevantSortController: relevantSortController,
                hitsController: hitsController,
                statsController: statsController)
  }
  

}
