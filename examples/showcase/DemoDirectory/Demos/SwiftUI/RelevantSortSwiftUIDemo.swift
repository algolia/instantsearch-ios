//
//  RelevantSortSwiftUIDemo.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 14/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI
import SDWebImageSwiftUI

struct RelevantSortDemoView: View {

  @ObservedObject var queryInputController: QueryInputObservableController
  @ObservedObject var hitsController: HitsObservableController<StockItem>

  @State private var isEditing = false

  var body: some View {
    VStack(spacing: 7) {
      SearchBar(text: $queryInputController.query,
                isEditing: $isEditing,
                onSubmit: queryInputController.submit)
      HitsList(hitsController) { (hit, _) in
        VStack(alignment: .leading, spacing: 10) {
          Text(hit?.name ?? "")
            .padding(.all, 10)
          Divider()
        }
      } noResults: {
        Text("No Results")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
  
}


struct RelevantSortDemoView_Previews : PreviewProvider {
  
  class ViewModel {
        
    let searcher: HitsSearcher
    let queryInputInteractor: QueryInputInteractor
    let queryInputController: QueryInputObservableController

    let hitsInteractor: HitsInteractor<StockItem>
    let hitsController: HitsObservableController<StockItem>
    
    let queryRuleCustomDataConnector: QueryRuleCustomDataConnector<Banner>
    let bannerController: BannerObservableController
    
    init() {
      searcher = HitsSearcher(client: .demo,
                              indexName: "instant_search")
      self.queryInputInteractor = .init()
      self.queryInputController = .init()
      self.hitsInteractor = .init()
      self.hitsController = .init()
      self.bannerController = .init()
      self.queryRuleCustomDataConnector = .init(searcher: searcher, controller: bannerController)
      setupConnections()
    }
    
    func setupConnections() {
       queryInputInteractor.connectSearcher(searcher)
       queryInputInteractor.connectController(queryInputController)
       hitsInteractor.connectSearcher(searcher)
       hitsInteractor.connectController(hitsController)
    }
    
  }
  
  static let viewModel = ViewModel()
  
  static var previews: some View {
    let contentView = RelevantSortDemoView(queryInputController: viewModel.queryInputController,
                                           hitsController: viewModel.hitsController)
    NavigationView {
      contentView
    }.onAppear {
      viewModel.searcher.search()
    }
  }
  
}


