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
  
  static let filterState = FilterState()
  static let interactor = NumberRangeInteractor<Int>()
  
  struct ContentView: View {
    
    @ObservedObject var numberRangeController: NumberRangeObservableController<Int>
    
    var body: some View {
      let range = numberRangeController.range
      VStack{
        Stepper(onIncrement: {
          if let range = makeRange(range.lowerBound+1, range.upperBound) {
            numberRangeController.range = range
          }
        },
        onDecrement: {
          if let range = makeRange(range.lowerBound-1, range.upperBound) {
            numberRangeController.range = range
          }
        },
        label: {
          Text("Lower bound: \(range.lowerBound)")
        })
        Stepper(onIncrement: {
          if let range = makeRange(range.lowerBound, range.upperBound+1) {
            numberRangeController.range = range
          }
        },
        onDecrement: {
          if let range = makeRange(range.lowerBound, range.upperBound-1) {
            numberRangeController.range = range
          }
        },
        label: {
          Text("Upper bound: \(numberRangeController.range.upperBound)")
        })
      }
    }
    
    func makeRange(_ lowerBound: Int, _ upperBound: Int) -> ClosedRange<Int>? {
      if lowerBound < upperBound &&
         numberRangeController.bounds.contains(lowerBound) &&
         numberRangeController.bounds.contains(upperBound) {
        return lowerBound...upperBound
      } else {
        return nil
      }
    }
    
  }
  
  static var previews: some View {
    let _ = interactor
    let _ = filterState
    let _ = interactor.connectFilterState(filterState, attribute: "range")
    let controller = NumberRangeObservableController<Int>(range: 4...10,
                                                          bounds: 0...20)
    let _ = interactor.connectController(controller)
    ContentView(numberRangeController: controller)
  }
  
}
