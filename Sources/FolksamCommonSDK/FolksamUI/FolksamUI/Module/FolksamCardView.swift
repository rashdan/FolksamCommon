//
//  FolksamCardView.swift
//  FolksamUI
//
//  Created by Johan Torell on 2021-06-28.
//

import SwiftUI

enum ImagePosition: String {
    case left
    case right
    case top
}

@IBDesignable
open class FolksamCardView: UIButton {
    private let label = UILabel()
    private let img = UIImageView()
    private let chevron = UIImageView()
    private var _axis = NSLayoutConstraint.Axis.vertical

    private var container = UIStackView()

    @IBInspectable var padding: CGFloat = 10

    @IBInspectable var axis: Int {
        get {
            return container.axis.rawValue
        }
        set {
            container.axis = NSLayoutConstraint.Axis(rawValue: newValue) ?? .vertical
        }
    }

    @IBInspectable public var titleText: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }

    @IBInspectable var titleFontSize: CGFloat = 15 {
        didSet {
            label.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        }
    }

    @IBInspectable var image: UIImage? {
        get {
            return img.image
        }
        set {
            img.image = newValue
        }
    }

    @IBInspectable var background: UIColor = .white {
        didSet {
            backgroundColor = background
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 12 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = false
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 12 {
        didSet {
            layer.shadowRadius = shadowRadius
            layer.shadowColor = UIColor.darkGray.cgColor
        }
    }

    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            layer.shadowOpacity = shadowOpacity
            layer.shadowColor = UIColor.darkGray.cgColor
        }
    }

    @IBInspectable var shadowOffset = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffset
            layer.shadowColor = UIColor.black.cgColor
            layer.masksToBounds = false
        }
    }

    @IBInspectable var hasChevron: Bool = false

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        container.axis = NSLayoutConstraint.Axis(rawValue: axis) ?? .horizontal
        container.alignment = .center
        container.distribution = .fillProportionally
        container.spacing = 10
        container.isUserInteractionEnabled = false

        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        if #available(iOS 11.0, *) {
            label.textColor = FolksamColor.Blue2m
        } else {
            // Fallback on earlier versions
        }

        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        setTitle(nil, for: .normal)

        container.addArrangedSubview(img)
        container.addArrangedSubview(label)

        if hasChevron {
            if #available(iOS 13.0, *) {
                chevron.image = UIImage(systemName: "chevron.right")
            } else {
                // Fallback on earlier versions
            }
            chevron.widthAnchor.constraint(equalToConstant: 15).isActive = true
            container.addArrangedSubview(chevron)
        } else {
            container.removeArrangedSubview(chevron)
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
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true

        img.translatesAutoresizingMaskIntoConstraints = false
        switch container.axis {
        case .horizontal:
            img.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
            img.addConstraint(NSLayoutConstraint(item: img, attribute: .width, relatedBy: .equal, toItem: img, attribute: .height, multiplier: 1, constant: 0))
            img.contentMode = .scaleAspectFit

        case .vertical:
            img.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1).isActive = true
            img.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1).isActive = true
//            img.addConstraint(NSLayoutConstraint(item: img, attribute: .height, relatedBy: .equal, toItem: img, attribute: .width, multiplier: 1, constant: 0))
            img.contentMode = .center
        }

        label.textAlignment = .left
        label.text = titleText
    }

    // MARK: - IB Setup

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
}
