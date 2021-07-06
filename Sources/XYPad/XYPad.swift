//
//  XYPad.swift
//
//  Created by Cem Olcay on 6/30/21.
//

import UIKit

public class XYPad: UIControl {
    public let labelFrameSize: CGFloat = 50
    public let xLabel = UILabel()
    public let yLabel = UILabel()
    public let pad = UIView()
    public let indicatorView = UIView()
    public let indicatorSize: CGFloat = 15

    public var resetsToCenter: Bool = false
    public var xLabelFormatter: ((Double) -> String)?
    public var yLabelFormatter: ((Double) -> String)?
    public let xLine = UIView()
    public let yLine = UIView()

    public var minXValue: Double = 0.0 { didSet { setNeedsLayout() }}
    public var maxXValue: Double = 1.0 { didSet { setNeedsLayout() }}
    public var xValue: Double = 0.5 {
        didSet {
            xValue = min(maxXValue, max(minXValue, xValue))
            setNeedsLayout()
        }
    }

    public var minYValue: Double = 0.0 { didSet { setNeedsLayout() }}
    public var maxYValue: Double = 1.0 { didSet { setNeedsLayout() }}
    public var yValue: Double = 0.5 {
        didSet {
            yValue = min(maxYValue, max(minYValue, yValue))
            setNeedsLayout()
        }
    }

    public init() {
        super.init(frame: .zero)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        addSubview(xLabel)
        addSubview(yLabel)
        addSubview(pad)
        pad.addSubview(indicatorView)

        xLabel.font = .systemFont(ofSize: 15)
        xLabel.textColor = .black
        xLabel.textAlignment = .center
        yLabel.font = .systemFont(ofSize: 15)
        yLabel.textColor = .black
        yLabel.textAlignment = .center

        indicatorView.frame = CGRect(x: 0, y: 0, width: indicatorSize, height: indicatorSize)
        indicatorView.backgroundColor = .red
        indicatorView.layer.cornerRadius = indicatorView.frame.size.height / 2.0

        pad.layer.borderColor = UIColor.black.cgColor
        pad.layer.borderWidth = 1.0

        pad.addSubview(xLine)
        xLine.backgroundColor = .black
        pad.addSubview(yLine)
        yLine.backgroundColor = .black
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        pad.frame = CGRect(
            x: labelFrameSize,
            y: 0,
            width: frame.size.width - labelFrameSize,
            height: frame.size.height - labelFrameSize)

        let x = convert(value: xValue, inRange: minXValue ... maxXValue, toRange: 0 ... Double(pad.frame.size.width))
        let y = convert(value: yValue, inRange: minYValue ... maxYValue, toRange: 0 ... Double(pad.frame.size.height))
        indicatorView.center = CGPoint(x: x, y: y)
        xLine.frame = CGRect(x: 0, y: 0, width: pad.frame.size.width, height: 1)
        xLine.center.y = CGFloat(y)
        yLine.frame = CGRect(x: 0, y: 0, width: 1, height: pad.frame.size.height)
        yLine.center.x = CGFloat(x)

        xLabel.frame = CGRect(
            x: 0,
            y: frame.size.height - labelFrameSize,
            width: labelFrameSize,
            height: labelFrameSize)
        yLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: labelFrameSize,
            height: 15)
        xLabel.center.x = CGFloat(x) + labelFrameSize
        yLabel.center.y = CGFloat(y)

        xLabel.text = xLabelFormatter?(xValue) ?? String(format: "%.2f", xValue)
        yLabel.text = yLabelFormatter?(yValue) ?? String(format: "%.2f", yValue)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let location = touches.first?.location(in: self) else { return }
        updateValue(location: location)
        sendActions(for: .editingDidBegin)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let location = touches.first?.location(in: self) else { return }
        updateValue(location: location)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let location = touches.first?.location(in: self) else { return }
        updateValue(location: location)
        sendActions(for: .editingDidEnd)

        if resetsToCenter {
            updateValue(location: pad.center)
        }
    }

    public func updateValue(location: CGPoint) {
        let clampedLocation = CGPoint(
            x: min(max(location.x, labelFrameSize), frame.size.width),
            y: min(max(location.y, 0), frame.size.height - labelFrameSize))
        let xyLocation = convert(clampedLocation, to: pad)

        xValue = convert(
            value: Double(xyLocation.x),
            inRange: 0 ... Double(pad.frame.size.width),
            toRange: minXValue ... maxXValue)
        yValue = convert(
            value: Double(xyLocation.y),
            inRange: 0 ... Double(pad.frame.size.height),
            toRange: minYValue ... maxYValue)

        sendActions(for: .valueChanged)
    }

    private func convert<T: FloatingPoint>(value: T, inRange: ClosedRange<T>, toRange: ClosedRange<T>) -> T {
      let oldRange = inRange.upperBound - inRange.lowerBound
      let newRange = toRange.upperBound - toRange.lowerBound
      return (((value - inRange.lowerBound) * newRange) / oldRange) + toRange.lowerBound
    }
}
