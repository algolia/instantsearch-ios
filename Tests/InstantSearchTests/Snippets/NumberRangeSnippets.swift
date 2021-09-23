//
//  NumberRangeSnippets.swift
//  
//
//  Created by Vladislav Fitc on 03/09/2020.
//

import Foundation
import InstantSearch
#if canImport(UIKit) && !os(watchOS)
import UIKit

class NumberRangeSnippets {
    
  func widgetSnippet() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourApiKey",
                                              indexName: "YourIndexName")
    let filterState: FilterState = .init()
    
    let numberRangeController: RangeSliderController = .init(rangeSlider: .init())
    
    let numericRangeConnector: NumberRangeConnector<Double> = .init(searcher: searcher,
                                                                    filterState: filterState,
                                                                    attribute: "price",
                                                                    controller: numberRangeController)
    
    searcher.search()
    
    _ = numericRangeConnector
  }
  
  func advancedSnippet() {
    let searcher: SingleIndexSearcher = .init(appID: "YourApplicationID",
                                              apiKey: "YourApiKey",
                                              indexName: "YourIndexName")
    let filterState: FilterState = .init()

    let numericRangeInteractor: NumberRangeInteractor<Double> = .init()
    let numberRangeController: RangeSliderController = .init(rangeSlider: .init())

    let priceAttribute: Attribute = "price"
      
    searcher.connectFilterState(filterState)

    numericRangeInteractor.connectFilterState(filterState, attribute: priceAttribute)
    numericRangeInteractor.connectSearcher(searcher, attribute: priceAttribute)
    numericRangeInteractor.connectController(numberRangeController)
    
    searcher.search()
  
  }
  
  class RangeSlider: UIControl {
    var lowerValue: Double = 0
    var upperValue: Double = 0
    var minimumValue: Double = 0
    var maximumValue: Double = 0
  }
  
  class RangeSliderController: NumberRangeController {
    
    let rangeSlider: RangeSlider

    var onRangeChanged: ((ClosedRange<Double>) -> Void)?
    
    func setBounds(_ bounds: ClosedRange<Double>) {
      rangeSlider.minimumValue = bounds.lowerBound
      rangeSlider.maximumValue = bounds.upperBound
      setItem(bounds)
    }
    
    func setItem(_ item: ClosedRange<Double>) {
      rangeSlider.lowerValue = item.lowerBound
      rangeSlider.upperValue = item.upperBound
    }
    
    init(rangeSlider: RangeSlider) {
      self.rangeSlider = rangeSlider
      rangeSlider.addTarget(self, action: #selector(onValueChanged(sender:)), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc func onValueChanged(sender: RangeSlider) {
      onRangeChanged?(sender.lowerValue...sender.upperValue)
    }
    
  }
  
}
#endif
