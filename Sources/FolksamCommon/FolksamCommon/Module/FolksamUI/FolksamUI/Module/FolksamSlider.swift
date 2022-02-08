//
//  FolksamSlider.swift
//  FolksamUI
//
//  Created by Jonas Bengtås Clarstedt on 2021-06-29.
//

#if !os(macOS)
import UIKit

@IBDesignable
open class FolksamSlider: UISlider {
    private let valueLabel = UILabel()

    let fmt: NumberFormatter = {
        let n = NumberFormatter()
        n.usesGroupingSeparator = true
        n.numberStyle = .currency
        return n
    }()

    private let editButton = UIImageView()

    private var container = UIStackView()

    @IBInspectable var padding: CGFloat = 10

    @IBInspectable var step: Int = 0

    @IBInspectable var labelFormaterStyle = NumberFormatter.Style.currency {
        didSet {
            fmt.numberStyle = labelFormaterStyle
        }
    }

    @IBInspectable var valueFontSize: CGFloat = 12 {
        didSet {
            valueLabel.font = UIFont.systemFont(ofSize: valueFontSize)
        }
    }

    @IBInspectable override open var value: Float {
        didSet {
            updateTextFromValue()
        }
    }

    @IBInspectable var background: UIColor = .white {
        didSet {
            backgroundColor = background
        }
    }

    @IBInspectable var hasEdit: Bool = true

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func updateTextFromValue() {
        valueLabel.text = fmt.string(from: NSNumber(value: value))
        valueLabel.sizeToFit()
    }

    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = 8
        return newRect
    }

    func shouldSnap(slider: FolksamSlider) -> Float {
        let step1 = (step != 0) ? Int(step) : Int(slider.maximumValue / 50)
        let m = Int(slider.value) % step1
        let n = Int(slider.value) / step1

        if m < step1 / 4 {
            return Float(step1 * n)
        } else if m > step1 - step1 / 4 {
            return Float(step1 * (n + 1))
        }

        return slider.value
    }

    @objc func valueChangedOfSlider(slider: FolksamSlider) {
        slider.value = roundf(slider.value)

        updateTextFromValue()

        moveLabel(slider: slider)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        moveLabel(slider: self)
    }

    func moveLabel(slider: FolksamSlider) {
        let trackRect = slider.trackRect(forBounds: slider.frame)
        let thumbRect = slider.thumbRect(forBounds: slider.bounds, trackRect: trackRect, value: slider.value)

        valueLabel.center = CGPoint(x: thumbRect.midX - 54, y: valueLabel.center.y)
    }

    private func setup() {
        minimumTrackTintColor = FolksamColor.Blue2
        thumbTintColor = FolksamColor.Blue2

        let img = UIImage(data: (UIImage(systemName: "shield.fill")?.pngData()!)!, scale: CGFloat(8))!.withTintColor(FolksamColor.Blue2).withRenderingMode(.alwaysTemplate)
        setThumbImage(img, for: .normal)

        valueLabel.lineBreakMode = .byWordWrapping
        updateTextFromValue()

        valueLabel.layer.cornerRadius = 2
        valueLabel.numberOfLines = 1
        valueLabel.font = UIFont.systemFont(ofSize: valueFontSize)
        valueLabel.textColor = FolksamColor.Gray3
        valueLabel.frame = CGRect(x: 0, y: 35, width: 0, height: 0).integral

        moveLabel(slider: self)

        addSubview(valueLabel)

        addTarget(self, action: #selector(valueChangedOfSlider(slider:)), for: .valueChanged)
    }

    // MARK: - IB Setup

    override public func prepareForInterfaceBuilder() {
        setup()
    }
}
#endif
