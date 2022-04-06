//
//  FilterListSwiftUIDemoViewController.swift
//  Examples
//
//  Created by Vladislav Fitc on 06.04.2022.
//

import Foundation
import UIKit
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

class FilterListSwiftUIDemoViewController<F: FilterType & Hashable>: UIHostingController<FilterListDemoView<F>> {
  
  let demoController: FilterListDemoController<F>
  let filtersObservableController: FilterListObservableController<F>
  let filterStateObservable: FilterStateObservable
  
  init(filters: [F],
       title: String,
       description: @escaping (F) -> String) {
    filtersObservableController = FilterListObservableController<F>()
    demoController = FilterListDemoController(filters: filters,
                                              controller: filtersObservableController,
                                              selectionMode: .multiple)
    filterStateObservable = .init(filterState: demoController.filterState)
    let contentView = FilterListDemoView(filterState: filterStateObservable,
                                         controller: filtersObservableController,
                                         description: description,
                                         title: title)
    super.init(rootView: contentView)
    UIScrollView.appearance().keyboardDismissMode = .interactive

  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
