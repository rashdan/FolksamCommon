//
//  CardView.swift
//  Home
//
//  Created by Johan Torell on 2021-02-25.
//

import Foundation

#if !os(macOS)
import UIKit

@IBDesignable class CardView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 20
    @IBInspectable var shadowOffsetWidth: CGFloat = 0
    @IBInspectable var shadowOffsetHeight: CGFloat = 5
    @IBInspectable var shadowColor = UIColor.gray
    @IBInspectable var shadowOpacity: CGFloat = 0.5
    @IBInspectable var shadowRadius: CGFloat = 2

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowRadius = shadowRadius

        //        box.layer.shouldRasterize = true
        //        box.layer.rasterizationScale = UIScreen.main.scale
    }
}
#endif
