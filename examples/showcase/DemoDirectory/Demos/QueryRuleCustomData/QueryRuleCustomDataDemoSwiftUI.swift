//
//  QueryRuleCustomDataSwiftUIDemo.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI
import SDWebImageSwiftUI

struct StockItem: Codable {
  let name: String
}

struct QRCDContentView: View {
  
  @ObservedObject var queryInputController: QueryInputObservableController
  @ObservedObject var hitsController: HitsObservableController<StockItem>
  @ObservedObject var bannerController: BannerObservableController

  @State private var isEditing = false
  @State private var isShowingAlert = false
  
  @ViewBuilder func getView(for banner: Banner?) -> some View {
    if let banner = bannerController.banner {
      if let imageURL = banner.banner {
        WebImage(url: imageURL)
          .resizable()
          .aspectRatio(contentMode: .fit)
      } else if let title = banner.title {
        Text(title)
          .font(.headline)
          .foregroundColor(.white)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color(.algoliaCyan))
      } else {
        let _ = isShowingAlert = true
        EmptyView()
      }
    } else {
      let _ = isShowingAlert = false
      EmptyView()
    }

  }
  
  var body: some View {
    VStack(spacing: 7) {
      SearchBar(text: $queryInputController.query,
                isEditing: $isEditing,
                onSubmit: queryInputController.submit)
        .padding(.horizontal)
      getView(for: bannerController.banner).onTapGesture {
        (bannerController.banner?.link).flatMap({ UIApplication.shared.open($0) })
      }
      HitsList(hitsController) { (hit, _) in
        VStack(alignment: .leading, spacing: 10) {
          Text(hit?.name ?? "")
            .padding(.all, 10)
          Divider()
        }
      } noResults: {
        Text("No Results")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }.alert(isPresented: $isShowingAlert) {
        Alert(title: Text("Hello"), message: Text("world"), dismissButton: .cancel())
      }.padding(.horizontal)
    }
  }
}

class BannerObservableController: ObservableObject, ItemController {
  
  @Published var banner: Banner?
  
  func setItem(_ item: Banner?) {
    self.banner = item
  }
  
}

struct QRCDContentView_Previews : PreviewProvider {
  
  class ViewModel {
        
    let searcher: HitsSearcher
    let queryInputInteractor: QueryInputInteractor
    let queryInputController: QueryInputObservableController

    let hitsInteractor: HitsInteractor<StockItem>
    let hitsController: HitsObservableController<StockItem>
    
    let queryRuleCustomDataConnector: QueryRuleCustomDataConnector<Banner>
    let bannerController: BannerObservableController
    
    init() {
      searcher = HitsSearcher(client: .demo, indexName: "instant_search")
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
    let contentView = QRCDContentView(queryInputController: viewModel.queryInputController,
                                      hitsController: viewModel.hitsController,
                                      bannerController: viewModel.bannerController).navigationBarTitle("Redirect")
    NavigationView {
      contentView
    }.onAppear {
      viewModel.searcher.search()
    }
  }
  
}
