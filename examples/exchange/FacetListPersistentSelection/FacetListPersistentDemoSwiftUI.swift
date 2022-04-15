//
//  FacetListPersistentDemoSwiftUI.swift
//  Examples
//
//  Created by Vladislav Fitc on 15/04/2022.
//

import Foundation
import SwiftUI
import InstantSearchSwiftUI

struct FacetListPersistentDemoSwiftUI: PreviewProvider {
  
  class Controller {
    
    let demoController: FacetListPersistentSelectionDemoController
    let filterStateController: FilterStateObservableController
    let colorController: FacetListObservableController
    let categoryController: FacetListObservableController
    
    init() {
      demoController = .init()
      filterStateController = .init(filterState: demoController.filterState)
      colorController = .init()
      categoryController = .init()
      demoController.categoryConnector.connectController(categoryController)
      demoController.colorConnector.connectController(colorController)
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var colorController: FacetListObservableController
    @ObservedObject var categoryController: FacetListObservableController
    
    var body: some View {
      VStack(spacing: 20) {
        FilterStateDebugView(filterStateController)
        HStack(alignment: .top) {
          ScrollView {
            Section {
              FacetList(colorController) { facet, isSelected in
                FacetRow(facet: facet, isSelected: isSelected)
                  .padding()
                Divider()
              }
            } header: {
              header(withTitle: "Multiple choice")
                .foregroundColor(Color.red)
            }
          }
          ScrollView {
            Section {
              FacetList(categoryController) { facet, isSelected in
                FacetRow(facet: facet, isSelected: isSelected)
                  .padding()
                Divider()
              }
            } header: {
              header(withTitle: "Single choice")
                .foregroundColor(Color.blue)
            }
          }
        }
        Spacer()
      }
      .padding()
    }
    
    @ViewBuilder func header(withTitle title: String) -> some View {
      Text(title)
        .font(.footnote)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGray5))
    }
    
  }
  
  class ViewController: UIHostingController<ContentView> {
    
    let controller: Controller
    
    init() {
      controller = .init()
      let contentView = ContentView(filterStateController: controller.filterStateController,
                                    colorController: controller.colorController,
                                    categoryController: controller.categoryController)
      super.init(rootView: contentView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
  
  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      ContentView(filterStateController: controller.filterStateController,
                  colorController: controller.colorController,
                  categoryController: controller.categoryController)
      .navigationBarTitle("Facet List Persistent Selection")
    }
  }
  
}
