//
//  SliderView.swift
//  Examples
//
//  Created by Vladislav Fitc on 13/04/2022.
//

import SwiftUI
import Combine

// SliderValue to restrict double range: 0.0 to 1.0
@propertyWrapper
struct SliderValue: Equatable {
  var value: Double

  init(wrappedValue: Double) {
    self.value = wrappedValue
  }

  var wrappedValue: Double {
    get { value }
    set { value = min(max(0.0, newValue), 1.0) }
  }
}

extension SliderValue: ExpressibleByFloatLiteral {

  init(floatLiteral value: Double) {
    self.value = value
  }

}

class SliderHandle: ObservableObject {

  // Slider Size
  let sliderWidth: CGFloat
  let sliderHeight: CGFloat

  // Slider Range
  let sliderValueStart: Double
  let sliderValueRange: Double

  // Slider Handle
  var diameter: CGFloat = 30
  var startLocation: CGPoint

  var lowerBoundPercentage: Double = 0
  var upperBoundPercentage: Double = 100

  // Current Value
  @Published var currentPercentage: SliderValue

  // Slider Button Location
  @Published var onDrag: Bool
  @Published var currentLocation: CGPoint

  init(sliderWidth: CGFloat, sliderHeight: CGFloat, sliderValueStart: Double, sliderValueEnd: Double, startPercentage: SliderValue) {
    self.sliderWidth = sliderWidth
    self.sliderHeight = sliderHeight

    self.sliderValueStart = sliderValueStart
    self.sliderValueRange = sliderValueEnd - sliderValueStart

    let startLocation = CGPoint(x: (CGFloat(startPercentage.wrappedValue)/1.0)*sliderWidth, y: sliderHeight/2)

    self.startLocation = startLocation
    self.currentLocation = startLocation
    self.currentPercentage = startPercentage
    self.onDrag = false
  }

  lazy var sliderDragGesture: _EndedGesture<_ChangedGesture<DragGesture>>  = DragGesture()
    .onChanged { value in
      self.onDrag = true

      let dragLocation = value.location

      // Restrict possible drag area
      self.restrictSliderBtnLocation(dragLocation)

      // Get current value
      self.currentPercentage.wrappedValue = Double(self.currentLocation.x / self.sliderWidth)

    }.onEnded { _ in
      self.onDrag = false
    }

  private func restrictSliderBtnLocation(_ dragLocation: CGPoint) {
    let expectedPercentage = dragLocation.x > 0 ? dragLocation.x / sliderWidth : 0
    guard expectedPercentage >= lowerBoundPercentage && expectedPercentage <= upperBoundPercentage else {
      return
    }
    // On Slider Width
    if dragLocation.x < .zero {
      calcSliderBtnLocation(CGPoint(x: 0, y: dragLocation.y))
    } else if dragLocation.x > sliderWidth {
      calcSliderBtnLocation(CGPoint(x: sliderWidth, y: dragLocation.y))
    } else {
      calcSliderBtnLocation(dragLocation)
    }
  }

  private func calcSliderBtnLocation(_ dragLocation: CGPoint) {
    if dragLocation.y != sliderHeight/2 {
      currentLocation = CGPoint(x: dragLocation.x, y: sliderHeight/2)
    } else {
      currentLocation = dragLocation
    }
  }

  // Current Value
  var currentValue: Double {
    get {
      return (sliderValueStart + currentPercentage.wrappedValue * sliderValueRange).rounded(toPlaces: 2)
    }

    set {
      guard newValue <= sliderValueStart + sliderValueRange else { return }
      let newPercentage = (newValue - sliderValueStart) / sliderValueRange
      currentPercentage = SliderValue(wrappedValue: newPercentage)
      currentLocation = CGPoint(x: currentPercentage.value * sliderWidth, y: currentLocation.y)
    }
  }
}

class CustomSlider: ObservableObject {

  // Slider Size
  final let width: CGFloat = 300
  final let lineWidth: CGFloat = 8

  // Slider value range from valueStart to valueEnd
  final let valueStart: Double
  final let valueEnd: Double

  // Slider Handle
  @Published var highHandle: SliderHandle
  @Published var lowHandle: SliderHandle

  final var anyCancellableHigh: AnyCancellable?
  final var anyCancellableLow: AnyCancellable?

  init(start: Double,
       end: Double,
       highStartPercentage: SliderValue = 1.0,
       lowStartPercentage: SliderValue = 0.0) {
    valueStart = start
    valueEnd = end

    highHandle = SliderHandle(sliderWidth: width,
                              sliderHeight: lineWidth,
                              sliderValueStart: valueStart,
                              sliderValueEnd: valueEnd,
                              startPercentage: highStartPercentage
    )

    lowHandle = SliderHandle(sliderWidth: width,
                             sliderHeight: lineWidth,
                             sliderValueStart: valueStart,
                             sliderValueEnd: valueEnd,
                             startPercentage: lowStartPercentage
    )

    anyCancellableHigh = highHandle.objectWillChange.sink { _ in
      self.lowHandle.upperBoundPercentage = self.highHandle.currentPercentage.value
      self.objectWillChange.send()
    }
    anyCancellableLow = lowHandle.objectWillChange.sink { _ in
      self.highHandle.lowerBoundPercentage = self.lowHandle.currentPercentage.value
      self.objectWillChange.send()
    }
  }

  convenience init(bounds: ClosedRange<Double>, values: ClosedRange<Double>) {
    let highStartPercentage = values.upperBound / bounds.upperBound
    let lowStartPercentage = values.lowerBound / (bounds.upperBound - bounds.lowerBound)
    self.init(start: bounds.lowerBound,
              end: bounds.upperBound,
              highStartPercentage: SliderValue(wrappedValue: highStartPercentage),
              lowStartPercentage: SliderValue(wrappedValue: lowStartPercentage))
  }

  var bounds: ClosedRange<Double> {
    return valueStart...valueEnd
  }

  var range: ClosedRange<Double> {
    return lowHandle.currentValue...highHandle.currentValue
  }

  // Percentages between high and low handle
  var percentagesBetween: String {
    return String(format: "%.2f", highHandle.currentPercentage.wrappedValue - lowHandle.currentPercentage.wrappedValue)
  }

  // Value between high and low handle
  var valueBetween: String {
    return String(format: "%.2f", highHandle.currentValue - lowHandle.currentValue)
  }
}

struct SliderView: View {
  @ObservedObject var slider: CustomSlider

  var body: some View {
    RoundedRectangle(cornerRadius: slider.lineWidth)
      .fill(Color.gray.opacity(0.2))
      .frame(width: slider.width, height: slider.lineWidth)
      .overlay(
        ZStack {
          // Path between both handles
          SliderPathBetweenView(slider: slider)

          // Low Handle
          SliderHandleView(handle: slider.lowHandle)
            .highPriorityGesture(slider.lowHandle.sliderDragGesture)

          // High Handle
          SliderHandleView(handle: slider.highHandle)
            .highPriorityGesture(slider.highHandle.sliderDragGesture)
        }
      )
  }

}

struct SliderHandleView: View {
  @ObservedObject var handle: SliderHandle

  var body: some View {
    Circle()
      .frame(width: handle.diameter, height: handle.diameter)
      .foregroundColor(.white)
      .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 0)
      .scaleEffect(handle.onDrag ? 1.3 : 1)
      .contentShape(Rectangle())
      .position(x: handle.currentLocation.x, y: handle.currentLocation.y)
  }
}

struct SliderPathBetweenView: View {
  @ObservedObject var slider: CustomSlider

  var body: some View {
    Path { path in
      path.move(to: slider.lowHandle.currentLocation)
      path.addLine(to: slider.highHandle.currentLocation)
    }
    .stroke(Color(.tintColor), lineWidth: slider.lineWidth)
  }
}
