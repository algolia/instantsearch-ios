//
//  RatingView.swift
//  Examples
//
//  Created by Vladislav Fitc on 14/04/2022.
//

import Foundation
import SwiftUI
import InstantSearch

struct RatingView: UIViewRepresentable {

  @Binding var value: Double

  func makeUIView(context: Context) -> RatingControl {
    let ratingControl = RatingControl()
    ratingControl.addTarget(context.coordinator, action: #selector(context.coordinator.valueChanged), for: .valueChanged)
    return ratingControl
  }

  func updateUIView(_ uiView: RatingControl, context: Context) {
    guard uiView.value != value else { return }
    uiView.value = value
  }

  class Coordinator: NSObject {

    var onValueChange: (Double) -> Void

    init(onValueChange: @escaping (Double) -> Void) {
      self.onValueChange = onValueChange
    }

    @objc func valueChanged(_ sender: RatingControl) {
      onValueChange(sender.value)
    }

  }

  func makeCoordinator() -> Coordinator {
    Coordinator { value in
      self.value = value
    }
  }

}
