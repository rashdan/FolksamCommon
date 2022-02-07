//
//  FolksamButton.swift
//  FolksamApp
//
//  Created by Johan Torell on 2021-01-28.
//

import UIKit

@available(iOS 11.0, *)
@IBDesignable public class FolksamButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 12.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var color: UIColor = FolksamColor.Green1 {
        didSet {
            backgroundColor = color
        }
    }

    public var enable: Bool {
        get { return isEnabled }
        set { isEnabled = newValue
            isUserInteractionEnabled = newValue
            updateAppearence()
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

    // MARK: - UI Setup

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    internal func setup() {
        backgroundColor = color
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius

        titleLabel?.textColor = .white
        titleLabel?.adjustsFontSizeToFitWidth = true
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .disabled)
    }

    private func updateAppearence() {
        if isEnabled {
            alpha = 1
            backgroundColor = FolksamColor.Green1
        } else {
            alpha = 0.6
            backgroundColor = FolksamColor.Green1
        }
    }
}
