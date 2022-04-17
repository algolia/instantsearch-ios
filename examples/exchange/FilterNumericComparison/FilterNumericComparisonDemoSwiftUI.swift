//
//  FilterNumericComparisonDemoSwiftUI.swift
//  Examples
//
//  Created by Vladislav Fitc on 16/04/2022.
//

import Foundation
import SwiftUI
import InstantSearchCore
import InstantSearchSwiftUI

struct FilterNumericComparisonDemoSwiftUI: SwiftUIDemo, PreviewProvider {
  
  class Controller {
    
    let demoController: FilterNumericComparisonDemoController
    let yearController: NumberObservableController<Int>
    let priceController: NumberObservableController<Double>
    let filterStateController: FilterStateObservableController

    init() {
      demoController = .init()
      yearController = .init()
      priceController = .init()
      demoController.yearConnector.connectNumberController(yearController)
      demoController.priceConnector.connectNumberController(priceController)
      filterStateController = .init(filterState: demoController.filterState)
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var filterStateController: FilterStateObservableController
    @ObservedObject var priceController: NumberObservableController<Double>
    @ObservedObject var yearController: NumberObservableController<Int>
    
    @State private var yearValue: String = ""
    
    var body: some View {
      return VStack(spacing: 40){
        FilterStateDebugView(filterStateController)
        HStack() {
          Text("Year")
          Spacer()
          TextField("Year", text: $yearValue)
            .textFieldStyle(.roundedBorder)
            .frame(maxWidth: 80)
            .multilineTextAlignment(.trailing)
            .onSubmit {
              if let year = Int(yearValue) {
                yearController.number = year
              }
            }
        }
        HStack {
          Stepper(value: $priceController.number,
                  in: priceController.bounds,
                  step: 0.1) {
            HStack{
              Text("Price:")
              Spacer()
              Text(String(format: "%.2f", priceController.number))
            }
          }
        }
        Spacer()
      }
      .padding()
      .onAppear {
        yearValue = "\(yearController.number)"
      }
    }

  }
  
  static func contentView(with controller: Controller) -> ContentView {
    return ContentView(filterStateController: controller.filterStateController,
                       priceController: controller.priceController,
                       yearController: controller.yearController)
  }
  
  static let controller = Controller()
  static var previews: some View {
    _ = controller
    return NavigationView {
      contentView(with: controller)
    }
  }
  
}


public class NumberObservableController<Number: Numeric & Comparable>: ObservableObject, NumberController {
  
  @Published public var number: Number = 1 {
    didSet {
      guard number != oldValue else { return }
      computation.just(value: number)
    }
  }
  
  @Published public var bounds: ClosedRange<Number> = 0...10000
  
  private var computation: Computation<Number>!
  
  public func setItem(_ number: Number) {
    self.number = number
  }
  
  public func setBounds(bounds: ClosedRange<Number>?) {
    if let bounds = bounds {
      self.bounds = bounds
    }
  }
  
  public func setComputation(computation: Computation<Number>) {
    self.computation = computation
  }
      
}
