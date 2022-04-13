//
//  FilterNumberRangeDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct FilterNumberRangeDemoSwiftUI: PreviewProvider {
  
  class Controller {
    let demoController = FilterNumberRangeDemoController()
    let numberRangeController = NumberRangeObservableController<Double>(range: 0...5,
                                                                        bounds: 0...5)
    let filterStateController: FilterStateObservableController
    
    init() {
      demoController.rangeConnector.connectController(numberRangeController)
      filterStateController = .init(filterState: demoController.filterState)
    }
  }
  
  struct ContentView: View {
    
    @ObservedObject var slider = CustomSlider(bounds: 0.0...5, values: 0...5)
    @ObservedObject var numberRangeController: NumberRangeObservableController<Double>
    @ObservedObject var filterStateController: FilterStateObservableController
    
    var body: some View {
      let range = numberRangeController.range
      VStack(spacing: 40){
        FilterStateDebugView(filterStateController)
        HStack(spacing: 20) {
          Text("\(Int(numberRangeController.bounds.lowerBound))")
          SliderView(slider: slider)
          Text("\(Int(numberRangeController.bounds.upperBound))")
        }
        Spacer()
      }.onChange(of: slider.lowHandle.currentValue) { newValue in
        if let range = makeRange(newValue, range.upperBound) {
          numberRangeController.range = range
        }
      }.onChange(of: slider.highHandle.currentValue) { newValue in
        if let range = makeRange(range.lowerBound, newValue) {
          numberRangeController.range = range
        }
      }.onChange(of: numberRangeController.range) { newValue in
        slider.lowHandle.currentValue = newValue.lowerBound
        slider.highHandle.currentValue = newValue.upperBound
      }.padding()
    }
    
    func makeRange(_ lowerBound: Double, _ upperBound: Double) -> ClosedRange<Double>? {
      if lowerBound < upperBound &&
          numberRangeController.bounds.contains(lowerBound) &&
          numberRangeController.bounds.contains(upperBound) {
        return lowerBound...upperBound
      } else {
        return nil
      }
    }
    
  }
  
  class ViewController: UIHostingController<ContentView> {
    
    let controller: Controller
    
    init() {
      self.controller = .init()
      let contentView = ContentView(numberRangeController: controller.numberRangeController,
                                    filterStateController: controller.filterStateController)
      super.init(rootView: contentView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
  
  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return ContentView(numberRangeController: controller.numberRangeController,
                       filterStateController: controller.filterStateController)
  }
  
}
