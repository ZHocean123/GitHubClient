//
//  GradientTopicView.swift
//  GitHubClient_Example
//
//  Created by ocean zhang on 07/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class GradientTopicView: GradientView {

    let label = UILabel()
    let closeBtn = UIButton()

    @IBInspectable var topic: String = "" {
        willSet {
            if newValue != topic {
                label.text = newValue
                setNeedsLayout()
                invalidateIntrinsicContentSize()
            }
        }
        didSet {
            layoutIfNeeded()
        }
    }

    @IBInspectable var showClose: Bool = false {
        willSet {
            if newValue != showClose {
                if newValue {
                    addSubview(closeBtn)
                } else {
                    closeBtn.removeFromSuperview()
                }
                setNeedsLayout()
                invalidateIntrinsicContentSize()
            }
        }
        didSet {
            layoutIfNeeded()
        }
    }

    @IBInspectable var padding: CGFloat = 4 {
        willSet {
            if newValue != padding {
                setNeedsLayout()
                invalidateIntrinsicContentSize()
            }
        }
        didSet {
            layoutIfNeeded()
        }
    }

    override func commonInit() {
        super.commonInit()
        label.textColor = .white
        label.font = UIFont.regularFont

        closeBtn.setTitle("X", for: .normal)
        closeBtn.setTitleColor(.white, for: .normal)
        closeBtn.titleLabel?.font = UIFont.regularFont
        addSubview(label)
    }

    override var intrinsicContentSize: CGSize {
        return sizeThatFits(UILayoutFittingExpandedSize)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = label.sizeThatFits(UILayoutFittingExpandedSize)
        if showClose {
            let btnSize = CGSize(width: labelSize.height, height: labelSize.height)
            return CGSize(width: min(size.width, padding * 3 + labelSize.width + btnSize.width),
                          height: min(size.height, padding * 2 + labelSize.height))
        } else {
            return CGSize(width: min(size.width, padding * 2 + labelSize.width),
                          height: min(size.height, padding * 2 + labelSize.height))
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        let innerRect = UIEdgeInsetsInsetRect(bounds, insets)
        if showClose {
            let btnSize = CGSize(width: innerRect.height, height: innerRect.height)
            label.frame = CGRect(x: innerRect.minX,
                                 y: innerRect.minY,
                                 width: innerRect.width - padding - btnSize.width,
                                 height: innerRect.height)
            closeBtn.frame = CGRect(x: innerRect.maxX - btnSize.width,
                                    y: padding,
                                    width: btnSize.width,
                                    height: btnSize.height)
        } else {
            label.frame = innerRect
        }
    }
}
