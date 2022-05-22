//
//  FacetListPersistentDemoSwiftUI.swift
//  Examples
//
//  Created by Vladislav Fitc on 15/04/2022.
//

import Foundation
import SwiftUI
import InstantSearchSwiftUI

struct FacetListPersistentDemoSwiftUI: SwiftUIDemo, PreviewProvider {

  class Controller {

    let demoController: FacetListPersistentSelectionDemoController
    let clearFilterController: FilterClearObservableController
    let filterStateController: FilterStateObservableController
    let colorController: FacetListObservableController
    let categoryController: FacetListObservableController

    init() {
      demoController = .init()
      clearFilterController = .init()
      filterStateController = .init(filterState: demoController.filterState)
      colorController = .init()
      categoryController = .init()
      demoController.clearFilterConnector.connectController(clearFilterController)
      demoController.categoryConnector.connectController(categoryController)
      demoController.colorConnector.connectController(colorController)
    }

  }

  struct ContentView: View {

    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var clearFilterController: FilterClearObservableController

    @ObservedObject var colorController: FacetListObservableController
    @ObservedObject var categoryController: FacetListObservableController

    var body: some View {
      VStack(spacing: 20) {
        FilterStateDebugView(filterStateController: filterStateController,
                             clearFilterController: clearFilterController)
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

  static func contentView(with controller: Controller) -> ContentView {
    ContentView(filterStateController: controller.filterStateController,
                clearFilterController: controller.clearFilterController,
                colorController: controller.colorController,
                categoryController: controller.categoryController)
  }

  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Facet List Persistent Selection")
    }
  }

}
