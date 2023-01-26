//
//  RangeSlider.swift
//  CustomSliderExample
//
//  Created by William Archimede on 04/09/2014.
//  Copyright (c) 2014 HoodBrains. All rights reserved.
//

import QuartzCore
import UIKit

class RangeSliderTrackLayer: CALayer {
  weak var rangeSlider: RangeSlider?

  override func draw(in ctx: CGContext) {
    guard let slider = rangeSlider else {
      return
    }

    // Clip
    let cornerRadius = bounds.height * slider.curvaceousness / 2.0
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    ctx.addPath(path.cgPath)

    // Fill the track
    ctx.setFillColor(slider.trackTintColor.cgColor)
    ctx.addPath(path.cgPath)
    ctx.fillPath()

    // Fill the highlighted range
    ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
    let lowerValuePosition = CGFloat(slider.positionForValue(slider.lowerValue))
    let upperValuePosition = CGFloat(slider.positionForValue(slider.upperValue))
    let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
    ctx.fill(rect)
  }
}

class RangeSliderThumbLayer: CALayer {
  var highlighted: Bool = false {
    didSet {
      setNeedsDisplay()
    }
  }

  weak var rangeSlider: RangeSlider?

  var strokeColor: UIColor = .gray {
    didSet {
      setNeedsDisplay()
    }
  }

  var lineWidth: CGFloat = 0.5 {
    didSet {
      setNeedsDisplay()
    }
  }

  override func draw(in ctx: CGContext) {
    guard let slider = rangeSlider else {
      return
    }

    let thumbFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
    let cornerRadius = thumbFrame.height * slider.curvaceousness / 2.0
    let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)

    // Fill
    ctx.setFillColor(slider.thumbTintColor.cgColor)
    ctx.addPath(thumbPath.cgPath)
    ctx.fillPath()

    // Outline
    ctx.setStrokeColor(strokeColor.cgColor)
    ctx.setLineWidth(lineWidth)
    ctx.addPath(thumbPath.cgPath)
    ctx.strokePath()

    if highlighted {
      ctx.setFillColor(UIColor(white: 0.0, alpha: 0.1).cgColor)
      ctx.addPath(thumbPath.cgPath)
      ctx.fillPath()
    }
  }
}

@IBDesignable
public class RangeSlider: UIControl {
  @IBInspectable public var minimumValue: Double = 0.0 {
    willSet(newValue) {
      assert(newValue < maximumValue, "RangeSlider: minimumValue should be lower than maximumValue")
    }
    didSet {
      updateLayerFrames()
    }
  }

  @IBInspectable public var maximumValue: Double = 1.0 {
    willSet(newValue) {
      assert(newValue > minimumValue, "RangeSlider: maximumValue should be greater than minimumValue")
    }
    didSet {
      updateLayerFrames()
    }
  }

  @IBInspectable public var lowerValue: Double = 0.2 {
    didSet {
      if lowerValue < minimumValue {
        lowerValue = minimumValue
      }
      updateLayerFrames()
    }
  }

  @IBInspectable public var upperValue: Double = 0.8 {
    didSet {
      if upperValue > maximumValue {
        upperValue = maximumValue
      }
      updateLayerFrames()
    }
  }

  var gapBetweenThumbs: Double {
    return 0.5 * Double(thumbWidth) * (maximumValue - minimumValue) / Double(bounds.width)
  }

  @IBInspectable public var trackTintColor: UIColor = .init(white: 0.9, alpha: 1.0) {
    didSet {
      trackLayer.setNeedsDisplay()
    }
  }

  @IBInspectable public var trackHighlightTintColor: UIColor = .init(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) {
    didSet {
      trackLayer.setNeedsDisplay()
    }
  }

  @IBInspectable public var thumbTintColor: UIColor = .white {
    didSet {
      lowerThumbLayer.setNeedsDisplay()
      upperThumbLayer.setNeedsDisplay()
    }
  }

  @IBInspectable public var thumbBorderColor: UIColor = .gray {
    didSet {
      lowerThumbLayer.strokeColor = thumbBorderColor
      upperThumbLayer.strokeColor = thumbBorderColor
    }
  }

  @IBInspectable public var thumbBorderWidth: CGFloat = 0.5 {
    didSet {
      lowerThumbLayer.lineWidth = thumbBorderWidth
      upperThumbLayer.lineWidth = thumbBorderWidth
    }
  }

  @IBInspectable public var curvaceousness: CGFloat = 1.0 {
    didSet {
      if curvaceousness < 0.0 {
        curvaceousness = 0.0
      }

      if curvaceousness > 1.0 {
        curvaceousness = 1.0
      }

      trackLayer.setNeedsDisplay()
      lowerThumbLayer.setNeedsDisplay()
      upperThumbLayer.setNeedsDisplay()
    }
  }

  fileprivate var previouslocation = CGPoint()

  fileprivate let trackLayer = RangeSliderTrackLayer()
  fileprivate let lowerThumbLayer = RangeSliderThumbLayer()
  fileprivate let upperThumbLayer = RangeSliderThumbLayer()

  fileprivate var thumbWidth: CGFloat {
    return CGFloat(bounds.height)
  }

  override public var frame: CGRect {
    didSet {
      updateLayerFrames()
    }
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    initializeLayers()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    initializeLayers()
  }

  override public func layoutSublayers(of _: CALayer) {
    super.layoutSublayers(of: layer)
    updateLayerFrames()
  }

  fileprivate func initializeLayers() {
    layer.backgroundColor = UIColor.clear.cgColor

    trackLayer.rangeSlider = self
    trackLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(trackLayer)

    lowerThumbLayer.rangeSlider = self
    lowerThumbLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(lowerThumbLayer)

    upperThumbLayer.rangeSlider = self
    upperThumbLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(upperThumbLayer)
  }

  func updateLayerFrames() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)

    trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
    trackLayer.setNeedsDisplay()

    let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
    lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
    lowerThumbLayer.setNeedsDisplay()

    let upperThumbCenter = CGFloat(positionForValue(upperValue))
    upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
    upperThumbLayer.setNeedsDisplay()

    CATransaction.commit()
  }

  func positionForValue(_ value: Double) -> Double {
    return Double(bounds.width - thumbWidth) * (value - minimumValue) /
      (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
  }

  func boundValue(_ value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
    return min(max(value, lowerValue), upperValue)
  }

  // MARK: - Touches

  override public func beginTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
    previouslocation = touch.location(in: self)

    // Hit test the thumb layers
    if lowerThumbLayer.frame.contains(previouslocation) {
      lowerThumbLayer.highlighted = true
    } else if upperThumbLayer.frame.contains(previouslocation) {
      upperThumbLayer.highlighted = true
    }

    return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
  }

  override public func continueTracking(_ touch: UITouch, with _: UIEvent?) -> Bool {
    let location = touch.location(in: self)

    // Determine by how much the user has dragged
    let deltaLocation = Double(location.x - previouslocation.x)
    let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - bounds.height)

    previouslocation = location

    // Update the values
    if lowerThumbLayer.highlighted {
      lowerValue = boundValue(lowerValue + deltaValue, toLowerValue: minimumValue, upperValue: upperValue - gapBetweenThumbs)
    } else if upperThumbLayer.highlighted {
      upperValue = boundValue(upperValue + deltaValue, toLowerValue: lowerValue + gapBetweenThumbs, upperValue: maximumValue)
    }

    sendActions(for: .valueChanged)

    return true
  }

  override public func endTracking(_: UITouch?, with _: UIEvent?) {
    lowerThumbLayer.highlighted = false
    upperThumbLayer.highlighted = false
  }
}
