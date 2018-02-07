//
//  GradientView.swift
//  GitHubClient_Example
//
//  Created by ocean zhang on 07/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DynamicColor

@IBDesignable
class GradientView: UIView {
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(hex: 0x74F5AB).cgColor,
            UIColor(hex: 0x4AC1FF).cgColor
        ]
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.cornerRadius = 10
        return layer
    }()

    let shadowGradientLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        shadowOffset = CGSize(width: 2, height: 2)
        layer.addSublayer(shadowGradientLayer)
        layer.addSublayer(gradientLayer)
    }

    override var shadowOffset: CGSize {
        didSet {
            drawShadow()
        }
    }

    override var shadowRadius: CGFloat {
        didSet {
            drawShadow()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds

        let blurRadius = shadowRadius * 2

        let insets = UIEdgeInsets(top: -blurRadius * 2,
                                  left: -blurRadius * 2,
                                  bottom: -blurRadius * 2,
                                  right: -blurRadius * 2)
        let boundingRect = UIEdgeInsetsInsetRect(bounds, insets)

        shadowGradientLayer.frame = CGRect(x: boundingRect.origin.x + shadowOffset.width,
                                           y: boundingRect.origin.y + shadowOffset.height,
                                           width: boundingRect.width,
                                           height: boundingRect.height)
        drawShadow()
    }

    func drawShadow() {

        let blurRadius = shadowRadius * 2

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1)

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        gradientLayer.render(in: context)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }

        UIGraphicsEndImageContext()

        guard let blur = CIFilter(name: "CIGaussianBlur") else {
            return
        }

        blur.setDefaults()
        blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)

        let ciContext = CIContext(options: nil)

        guard let result = blur.value(forKey: kCIOutputImageKey) as? CIImage else {
            return
        }

        let insets = UIEdgeInsets(top: -blurRadius * 2,
                                  left: -blurRadius * 2,
                                  bottom: -blurRadius * 2,
                                  right: -blurRadius * 2)
        let boundingRect = UIEdgeInsetsInsetRect(bounds, insets)

        let cgImage = ciContext.createCGImage(result, from: boundingRect)

        shadowGradientLayer.contents = cgImage
    }
}
