//
//  RatingControl.swift
//  
//
//  Created by Vladislav Fitc on 05/11/2020.
//

import Foundation
#if canImport(UIKit) && (os(iOS) || os(macOS) || os(tvOS))
import UIKit

/// A control for setting a rating value.
///
/// The rating is represented as multiple points. The maximumValue defines how many points the control renders.
/// The images used for setup of one point can be set via **emptyImage**,  **partialImage** and **fullImage** properties.
///
/// # Rendering rules
/// The point is rendered as *empty*, if the difference between the integer part of rating value and the point index  is negative.
///
/// - Example: for rating 3.5, its integer part is 3, so the 5-th point (index 4) is rendered as empty
///
/// The point is rendered as *full*, if the difference between the integer part of rating value and the point index is greater than 1.
///
/// - Example: for rating 3.5, its integer part is 3, so the 3-rd point (index 2) is rendered as full
///
/// The point is rendered as *partial*, of the if the difference between the integer part of rating value and the point index is equal to 0 and the fractional part of rating value is greater or equal than 0.5. Otherwise it is rendered as empty.
///
/// - Example: for rating 3.5 its integer part is 3, the fractional part is 0.5, so the 4-th point (index 3) is rendered as partial while for rating 3.4, the fractional part is 0.4, so the 4-th point is rendered as empty.

public class RatingControl: UIControl {

  /// The numeric value of the rating control.
  ///
  /// The default value for this property is 0.
  public var value: Double = 0 {
    didSet {
      guard value != oldValue else {
        return
      }
      refresh()
      sendActions(for: .valueChanged)
    }
  }

  /// The highest possible numeric value for the rating control.
  ///
  /// The default value for this property is 5.
  public var maximumValue: Int = 5 {
    didSet {
      setupPoints()
    }
  }

  /// Whether the rating value can be changed by pan gesture
  ///
  /// The default value for this property is true.
  public var isPanGestureEnabled: Bool = true {
    didSet {
      panGestureRecognizer.isEnabled = isPanGestureEnabled
    }
  }

  /// The empty point image
  ///
  /// Default value is nil
  public var emptyImage: UIImage?

  /// The partial point image
  ///
  /// Default value is nil
  public var partialImage: UIImage?

  /// The full point image
  ///
  /// Default value is nil
  public var fullImage: UIImage?

  private let pointsStackView = UIStackView()

  private let panGestureRecognizer: UIPanGestureRecognizer

  public init() {
    self.panGestureRecognizer = UIPanGestureRecognizer()
    super.init(frame: .zero)
    setupView()
    if #available(iOS 13.0, tvOS 13.0, *) {
      emptyImage = UIImage(systemName: "star")
      partialImage = UIImage(systemName: "star.leadinghalf.fill")
      fullImage = UIImage(systemName: "star.fill")
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func didPan(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let touchCoordinateX = panGestureRecognizer.location(in: pointsStackView).x
    guard touchCoordinateX > 0 else {
      return
    }
    let capturedValue = Double(touchCoordinateX/pointsStackView.bounds.width) * Double(maximumValue)

    let (integerPart, fractionalPart) = extract(from: capturedValue)
    let formattedValue = Double(integerPart) + Double(fractionalPart)/10
    if formattedValue < 0 {
      value = 0
    } else if formattedValue > Double(maximumValue) {
      value = Double(maximumValue)
    } else {
      value = formattedValue
    }
  }

  @objc private func didtap(_ tapGestureRecognizer: UITapGestureRecognizer) {
    guard
      let tappedImageView = tapGestureRecognizer.view,
      let tappedImageViewIndex = pointsStackView.arrangedSubviews.firstIndex(of: tappedImageView) else { return }
    value = Double(tappedImageViewIndex + 1)
  }

}

private extension RatingControl {

  enum RatingPointState {
    case empty, partial, full
  }

  func setupView() {
    pointsStackView.translatesAutoresizingMaskIntoConstraints = false
    pointsStackView.distribution = .equalCentering
    pointsStackView.alignment = .center
    addSubview(pointsStackView)
    NSLayoutConstraint.activate([
      pointsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      pointsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      pointsStackView.topAnchor.constraint(equalTo: topAnchor),
      pointsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    panGestureRecognizer.addTarget(self, action: #selector(didPan(_:)))
    pointsStackView.addGestureRecognizer(panGestureRecognizer)
    setupPoints()
  }

  func setupPoints() {
    let pointsDiffCount = maximumValue - pointsStackView.arrangedSubviews.count
    guard pointsDiffCount != 0 else { return }
    if pointsDiffCount < 0 {
      for pointView in pointsStackView.arrangedSubviews.suffix(Int(pointsDiffCount.magnitude)) {
        pointsStackView.removeArrangedSubview(pointView)
        pointsStackView.removeFromSuperview()
      }
    } else {
      for _ in 0..<pointsDiffCount {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtap(_:))))
        pointsStackView.addArrangedSubview(imageView)
      }
    }
  }

  func image(for state: RatingPointState) -> UIImage? {
    switch state {
    case .empty:
      return emptyImage
    case .partial:
      return partialImage
    case .full:
      return fullImage
    }
  }

  func refresh() {
    let pointsCount = Int(maximumValue)
    let imageStates = (0..<pointsCount).map { stateOfPoint(withIndex: $0, for: value) }.map(image(for:))
    let imageViews = pointsStackView.arrangedSubviews.compactMap { $0 as? UIImageView }
    zip(imageStates, imageViews).forEach { image, imageView in imageView.image = image }
  }

  func fractionalString(for value: Double, fractionDigits: Int) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = fractionDigits
    formatter.maximumFractionDigits = fractionDigits
    return formatter.string(from: value as NSNumber) ?? "\(self)"
  }

  func extract(from value: Double) -> (integer: Int, fractional: Int) {
    let strings = fractionalString(for: value, fractionDigits: 1).split(separator: ".").map(String.init)
    let integerPart = Int(strings.first!)!
    let fractionalPart = Int(strings.last!)!
    return (integerPart, fractionalPart)
  }

  func stateOfPoint(withIndex pointIndex: Int, for value: Double) -> RatingPointState {
    let (integerPart, fractionalPart) = extract(from: value)
    switch integerPart - pointIndex {
    case ..<0:
      return .empty
    case 1...:
      return .full
    default:
      return (0..<5).contains(fractionalPart) ? .empty : .partial
    }
  }

}
#endif
