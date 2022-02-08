//
//  RoundButton.swift
//  FolksamUI
//
//  Created by Johan Torell on 2021-06-23.
//

import Foundation

#if !os(macOS)
import UIKit

@IBDesignable public class FolksamButtonRound: UIView {
    private let button = UIButton()
    private let titleLabel = UILabel()

    @IBInspectable var color: UIColor {
        get {
            return button.backgroundColor ?? .white
        }
        set {
            button.backgroundColor = newValue
        }
    }

    @IBInspectable var hasLabel: Bool = false {
        didSet {
            titleLabel.isHidden = !hasLabel
        }
    }

    @IBInspectable var title: String {
        get {
            return titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }

    @IBInspectable var buttonTitle: String {
        get {
            return button.titleLabel?.text ?? ""
        }
        set {
            button.setTitle(newValue, for: .normal)
        }
    }

    @IBInspectable var buttonFontSize: CGFloat {
        get {
            return button.titleLabel?.font.pointSize ?? 15
        }
        set {
            button.titleLabel?.font = button.titleLabel?.font.withSize(newValue)
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - IB Setup

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    public func addTarget(_: Any?, action _: Selector, for _: UIControl.Event) {
//        button.addTarget(target, action: action, for: event)
    }

    private func setup() {
        layoutIfNeeded()
        addSubview(button)
        addSubview(titleLabel)
        button.backgroundColor = color
//        button.setTitle(buttonTitle, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),

        ])

        button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1, constant: 0))

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: button.bottomAnchor).isActive = true

        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.isHidden = !hasLabel
    }

    override public class var requiresConstraintBasedLayout: Bool {
        return true
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.frame.height / 2
    }
}
#endif
