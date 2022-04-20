//
//  QueryRuleCustomDataSwiftUIDemo.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct QueryRuleCustomDataSwiftUI: SwiftUIDemo, PreviewProvider {
  
  class Controller {
    
    let demoController: QueryRuleCustomDataDemoController
    let queryInputController: QueryInputObservableController
    let bannerController: BannerObservableController
    let hitsController: HitsObservableController<Hit<Product>>
    
    init() {
      self.demoController = .init()
      self.queryInputController = .init()
      self.bannerController = .init()
      self.hitsController = .init()
      demoController.hitsConnector.connectController(hitsController)
      demoController.queryInputConnector.connectController(queryInputController)
      demoController.queryRuleCustomDataConnector.connectController(bannerController)
      demoController.searcher.search()
    }
  }
  
  struct ContentView: View {
    
    struct Redirect: Identifiable {
      var id: String { url }
      let url: String
    }
    
    @ObservedObject var queryInputController: QueryInputObservableController
    @ObservedObject var hitsController: HitsObservableController<Hit<Product>>
    @ObservedObject var bannerController: BannerObservableController
    
    @State private var isHelpPresented: Bool = false
    @State private var selectedRedirect: Redirect?
    
    var body: some View {
      VStack {
        if let imageURL = bannerController.banner?.banner {
          AsyncImage(url: imageURL,
                     content: { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .onTapGesture {
                handleBannerTap()
              }
          },
                     placeholder: {
            ProgressView()
          }
          )
        } else if let title = bannerController.banner?.title {
          Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.algoliaCyan))
            .frame(maxHeight: 44)
            .onTapGesture {
              handleBannerTap()
            }
        }
        HitsList(hitsController) { (hit, _) in
          VStack {
            ProductRow(productHit: hit!)
              .padding()
            Divider()
          }
          .frame(height: 130)
        } noResults: {
          Text("No Results")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .alert(item: $selectedRedirect) { redirect in
        Alert(title: Text("Redirect"),
              message: Text(redirect.id),
              dismissButton: .cancel())
        
      }
      .alert(isPresented: $isHelpPresented) {
        Alert(title: Text("Help"),
              message: Text(QueryRuleCustomDataDemoController.helpMessage),
              dismissButton: .default(Text("OK")))
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { isHelpPresented = true }) {
            Image(systemName: "info.circle.fill")
          }
        }
      }
      .safeAreaInset(edge: .top, alignment: .center, spacing: 0) {
        Color.clear
          .frame(height: 0)
          .background(Material.bar)
      }
      .searchable(text: $queryInputController.query)
      .onSubmit(of: .search) {
        handleSubmit()
      }
    }
    
    func handleSubmit() {
      guard let link = bannerController.banner?.link else {
        return
      }
      if link.absoluteString == "algoliademo://help" {
        selectedRedirect = .init(url: link.absoluteString)
      }
    }
    
    func handleBannerTap() {
      guard let link = bannerController.banner?.link else {
        return
      }
      switch link.absoluteString {
      case "algoliademo://discounts":
        selectedRedirect = Redirect(url: link.absoluteString)
      default:
        UIApplication.shared.open(link)
      }
    }
    
  }
  
  static func contentView(with controller: Controller) -> ContentView {
    ContentView(queryInputController: controller.queryInputController,
                hitsController: controller.hitsController,
                bannerController: controller.bannerController)
  }
  
  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Query Rule Custom Data")
    }
  }
  
}

class BannerObservableController: ObservableObject, ItemController {
  
  @Published var banner: Banner?
  
  func setItem(_ item: Banner?) {
    self.banner = item
  }
  
}
