//
//  FolksamSliderV2.swift
//  FolksamUI
//
//  Created by Jonas Bengtås Clarstedt on 2021-06-29.
//

import SwiftUI

public protocol FolksamSliderDelegate: UIViewController {
    func onChangeValue(sender: FolksamSliderV2, value: Float)
    func dragEnded()
}

public struct SliderParamters {
    public init(min: Float, step: Int, max: Float, startValue: Float) {
        self.min = min
        self.max = max
        self.step = step
        self.startValue = startValue
    }

    public let min: Float
    public let step: Int
    public let max: Float
    public let startValue: Float
}

@IBDesignable
open class FolksamSliderV2: UIControl {
    public weak var delegate: FolksamSliderDelegate?

    class CustomUISlider: UISlider {
        override func trackRect(forBounds bounds: CGRect) -> CGRect {
            var newRect = super.trackRect(forBounds: bounds)
            newRect.size.height = 8
            return newRect
        }

        override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
            var bounds: CGRect = self.bounds
            bounds = bounds.insetBy(dx: -100, dy: -15)
            return bounds.contains(point)
        }
    }

    class BorderLabel: UILabel {
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
            setBottomBorder()
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            setBottomBorder()
        }

        func setBottomBorder() {
            let borderWidth: CGFloat = 4.0 // Change this according to your needs
            let lineView = UIView(frame: CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth))
            if #available(iOS 11.0, *) {
                lineView.backgroundColor = FolksamColor.Green2
            } else {
                // Fallback on earlier versions
            }
            addSubview(lineView)
        }
    }

    private let slider = CustomUISlider()

    @IBInspectable var maximumFractionDigits: Int = 0 {
        didSet {
            fmt.maximumFractionDigits = maximumFractionDigits
        }
    }

    @IBInspectable var labelFormaterStyle = NumberFormatter.Style.currency {
        didSet {
            fmt.numberStyle = labelFormaterStyle
        }
    }

    let fmt: NumberFormatter = {
        let n = NumberFormatter()
        n.usesGroupingSeparator = true
        n.numberStyle = .decimal
        n.locale = Locale(identifier: "sv_SE")
        n.maximumFractionDigits = 0
        return n
    }()

    private let valueLabel = UILabel()
    private let editButton = UIImageView()

    private var container = UIStackView()

    @IBInspectable var padding: CGFloat = 10

    @IBInspectable var step: Int = 0

    @IBInspectable var labelSufix: String = "" {
        didSet {
            updateTextFromValue(v: slider.value)
        }
    }

    @IBInspectable var minimumValue: Float = 0 {
        didSet {
            slider.minimumValue = minimumValue /* - maximumValue/10;
             slider.maximumValue = maximumValue + maximumValue/10;*/
        }
    }

    @IBInspectable var maximumValue: Float = 1 {
        didSet {
            // updateWidthFromMax(maxValue: maximumValue)
            slider.maximumValue = maximumValue /* + maximumValue/10;

             slider.minimumValue = minimumValue - maximumValue/10;*/
        }
    }

    @IBInspectable public var value: Float = 0.5 {
        didSet {
            slider.value = value
            updateTextFromValue(v: value)
            // updateWidthFromMax(maxValue: maximumValue)
        }
    }

    public func getValue() -> Float {
        return value
    }

    @IBInspectable var valueFontSize: CGFloat = 12 {
        didSet {
            valueLabel.font = UIFont.systemFont(ofSize: valueFontSize)
        }
    }

    @IBInspectable var background: UIColor = .white {
        didSet {
            backgroundColor = background
        }
    }

    @IBInspectable var hasEdit: Bool = true
    @IBInspectable var useStep: Bool = false

    override public init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            setup()
        } else {
            // Fallback on earlier versions
        }
    }

    public func configure(_ params: SliderParamters) {
        slider.minimumValue = params.min
        slider.maximumValue = params.max
        step = Int(params.step)
        slider.value = params.startValue
        print(params)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        if #available(iOS 11.0, *) {
            setup()
        } else {
            // Fallback on earlier versions
        }
    }

    func shouldSnap(sliderArg: UISlider) -> Float {
        let step1 = (step != 0) ? Int(step) : Int(sliderArg.maximumValue / 50)
        let m = Int(sliderArg.value) % step1
        let n = Int(sliderArg.value) / step1

        if m < step1 / 2 {
            return Float(step1 * n)
        } else if m > step1 - step1 / 2 {
            return Float(step1 * (n + 1))
        }

        return sliderArg.value
    }

    @objc func valueChangedOfSlider(sliderArg: UISlider, for event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .moved:
                if useStep {
                    value = shouldSnap(sliderArg: sliderArg)

                } else {
                    value = roundf(sliderArg.value)
                }
                /*
                 if (sliderArg.value < minimumValue){
                     sliderArg.value = minimumValue;
                 } else if (sliderArg.value > maximumValue){
                     sliderArg.value = maximumValue;
                 }
                 */
                moveLabel(sliderArg: sliderArg)
                delegate?.onChangeValue(sender: self, value: value)
            case .ended:
                delegate?.dragEnded()
            default:
                break
            }
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        moveLabel(sliderArg: slider)
    }

    func moveLabel(sliderArg: UISlider) {
        let trackRect = sliderArg.trackRect(forBounds: sliderArg.frame)
        let thumbRect = sliderArg.thumbRect(forBounds: sliderArg.bounds, trackRect: trackRect, value: sliderArg.value)
        valueLabel.center = CGPoint(x: thumbRect.midX, y: thumbRect.midY)
    }

    private func updateTextFromValue(v: Float) {
        valueLabel.text = fmt.string(from: NSNumber(value: v))! + " " + labelSufix
        valueLabel.sizeToFit()
        valueLabel.frame = CGRect(x: 0, y: 0, width: valueLabel.frame.width + 18, height: 35).integral
    }

    @objc func moveLabelUp(sliderArg _: UISlider) {
        UIView.animate(withDuration: 0.2) {
            self.valueLabel.transform = CGAffineTransform(translationX: 0, y: -30)
        }
    }

    @objc func moveLabelDown(sliderArg _: UISlider) {
        UIView.animate(withDuration: 0.2) {
            self.valueLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }

    private func updateWidthFromMax(maxValue: Float) {
        updateTextFromValue(v: maxValue)
        valueLabel.sizeToFit()
        valueLabel.frame = CGRect(x: 0, y: 0, width: valueLabel.frame.width, height: 35).integral
        updateTextFromValue(v: slider.value)
    }

    @available(iOS 11.0, *)
    private func setup() {
        addSubview(slider)

        addSubview(valueLabel)

        slider.minimumTrackTintColor = FolksamColor.Blue2
        slider.thumbTintColor = FolksamColor.Blue2

        slider.maximumTrackTintColor = FolksamColor.Gray6

        slider.frame = CGRect(x: 0, y: 0, width: frame.width, height: 65).integral
        // slider.value = value;

        if #available(iOS 13.0, *) {
            let img = UIImage(data: (UIImage(systemName: "shield.fill")?.pngData()!)!, scale: CGFloat(3))!.withTintColor(FolksamColor.Blue2).withRenderingMode(.alwaysOriginal)
            slider.setThumbImage(img, for: .normal)
            slider.setThumbImage(img, for: .highlighted)

        } else {
            // Fallback on earlier versions
        }

        
        /* let img = UIImage(systemName: "circle.fill");
               img!.withRenderingMode(.alwaysTemplate);
               slider.setThumbImage(img, for: .normal)
         */

        valueLabel.lineBreakMode = .byWordWrapping
        valueLabel.layer.cornerRadius = 8
        valueLabel.layer.masksToBounds = true
        valueLabel.numberOfLines = 1
        valueLabel.font = UIFont.systemFont(ofSize: valueFontSize)
        valueLabel.textColor = .white
        valueLabel.backgroundColor = FolksamColor.Blue2
        valueLabel.textAlignment = .center
        /* updateTextFromValue(v: maximumValue);
         valueLabel.sizeToFit();
         print(valueLabel.frame);
         print(valueLabel.text);

         */
        valueLabel.frame = CGRect(x: 0, y: 0, width: valueLabel.frame.width, height: 35).integral
        // updateTextFromValue(v:slider.value)

        slider.addTarget(self, action: #selector(valueChangedOfSlider(sliderArg:for:)), for: .valueChanged)

        slider.addTarget(self, action: #selector(moveLabelUp(sliderArg:)), for: .touchDown)

        slider.addTarget(self, action: #selector(moveLabelDown(sliderArg:)), for: .touchUpInside)

        layoutSubviews()
        moveLabel(sliderArg: slider)

        /*
         container.axis = NSLayoutConstraint.Axis.init(rawValue: axis) ?? .horizontal
         container.alignment = .center
         container.distribution = .fill
         container.spacing = 10
         container.isUserInteractionEnabled = false

         label.lineBreakMode = .byWordWrapping
         label.numberOfLines = 2
         label.font = UIFont.systemFont(ofSize: titleFontSize)

         container.addArrangedSubview(img)
         container.addArrangedSubview(label)

         if hasEdit {
             editButton.image = UIImage(systemName: "chevron.right")
             editButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
             container.addArrangedSubview(editButton)
         } else {
             container.removeArrangedSubview(editButton)
         }

         addSubview(container)

         layer.cornerRadius = cornerRadius
         layer.shadowColor = UIColor.gray.cgColor
         layer.shadowOffset = shadowOffset
         layer.shadowRadius = shadowRadius
         layer.shadowOpacity = shadowOpacity
         backgroundColor = background
         img.image = image

         container.translatesAutoresizingMaskIntoConstraints = false
         container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding).isActive = true
         container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding).isActive = true
         container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding).isActive = true
         container.topAnchor.constraint(equalTo: self.topAnchor, constant: padding).isActive = true

         img.translatesAutoresizingMaskIntoConstraints = false
         switch container.axis {
         case .horizontal:
             img.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
             img.addConstraint(NSLayoutConstraint(item: img, attribute: .width, relatedBy: .equal, toItem: img, attribute: .height, multiplier: 1, constant: 0))

         case .vertical:
             img.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
             img.addConstraint(NSLayoutConstraint(item: img, attribute: .height, relatedBy: .equal, toItem: img, attribute: .width, multiplier: 1, constant: 0))
         }

         label.textAlignment = .left
         label.text = titleText*/
    }

    // MARK: - IB Setup

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        if #available(iOS 11.0, *) {
            setup()
        } else {
            // Fallback on earlier versions
        }
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 11.0, *) {
            setup()
        } else {
            // Fallback on earlier versions
        }
    }
}
