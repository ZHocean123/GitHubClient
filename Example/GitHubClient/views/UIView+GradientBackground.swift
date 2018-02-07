//
//  UIView+GradientBackground.swift
//  GitHubClient_Example
//
//  Created by ocean zhang on 07/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreImage

extension UIView {
    fileprivate static var gradientBackgroundKey = "gradientBackgroundKey"
    fileprivate static var gradientShadowKey = "gradientShadowKey"

    func addGradientBackground(_ colors: [UIColor],
                               cornerRadius: CGFloat,
                               shadowOffSet: CGSize,
                               shadowRadius: CGFloat) {
        backgroundColor = .clear
        layer.masksToBounds = false

        gradientBackgroundLayer.removeFromSuperlayer()
        gradientShadowLayer.removeFromSuperlayer()

        self.layer.insertSublayer(gradientBackgroundLayer, at: 0)
        self.layer.insertSublayer(gradientShadowLayer, at: 0)

        gradientBackgroundLayer.colors = colors.map({ $0.cgColor })
        gradientBackgroundLayer.cornerRadius = cornerRadius
        gradientBackgroundLayer.frame = bounds

        let blurRadius = shadowRadius * 2

        let insets = UIEdgeInsets(top: -blurRadius * 2,
                                  left: -blurRadius * 2,
                                  bottom: -blurRadius * 2,
                                  right: -blurRadius * 2)
        var boundingRect = UIEdgeInsetsInsetRect(bounds, insets)
        boundingRect.origin.x += shadowOffSet.width
        boundingRect.origin.y += shadowOffSet.height

        gradientShadowLayer.frame = boundingRect

        drawShadow(shadowRadius: shadowRadius, shadowOffSet: shadowOffSet)

        clipsToBounds = false
        layer.masksToBounds = false
    }

    func drawShadow(shadowRadius: CGFloat, shadowOffSet: CGSize) {

        let blurRadius = shadowRadius * 2

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1)

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        gradientBackgroundLayer.render(in: context)

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

        gradientShadowLayer.contents = cgImage
    }

    var gradientBackgroundLayer: CAGradientLayer {
        get {
            if let layer = objc_getAssociatedObject(self, &UIView.gradientBackgroundKey) as? CAGradientLayer {
                return layer
            } else {
                let layer = CAGradientLayer()
                layer.startPoint = CGPoint(x: 1, y: 0)
                layer.endPoint = CGPoint(x: 0, y: 1)
                layer.cornerRadius = 10
                objc_setAssociatedObject(self,
                                             &UIView.gradientBackgroundKey,
                                         layer,
                                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                return layer
            }
        }
    }

    var gradientShadowLayer: CALayer {
        get {
            if let layer = objc_getAssociatedObject(self, &UIView.gradientShadowKey) as? CALayer {
                return layer
            } else {
                let layer = CALayer()
                objc_setAssociatedObject(self,
                                             &UIView.gradientShadowKey,
                                         layer,
                                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                return layer
            }
        }
    }

}
