//
//  IssueTagView.swift
//  GitHubClient_Example
//
//  Created by yang on 18/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DynamicColor

@IBDesignable
class IssueTagView: UIView {
    enum IssueType: Int {
        case openIssue
        case closedIssue
        case openMerge
        case merged
        case none
    }

    @IBInspectable var typeNumer: Int = 0 {
        didSet {
            type = IssueType(rawValue: typeNumer % 4) ?? .none
        }
    }

    var type: IssueType = .none {
        didSet {
            switch type {
            case .openIssue:
                backgroundColor = UIColor(hex: 0x2cbe4e)
                label.text = "\u{e623} Open"
            case .closedIssue:
                backgroundColor = UIColor(hex: 0xcb2431)
                label.text = "\u{e625} Closed"
            case .openMerge:
                backgroundColor = UIColor(hex: 0x2cbe4e)
                label.text = "\u{e896} Open"
            case .merged:
                backgroundColor = UIColor(hex: 0x6f42c1)
                label.text = "\u{e623} Merged"
            default:
                break
            }
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    let imageView = UIImageView()
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    var insets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8) {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    @IBInspectable var padding: CGFloat = 4 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    func commonInit() {
        addSubview(imageView)
        addSubview(label)

        label.textColor = .white
        label.font = UIFont(name: "iconfont", size: 14)
        layer.cornerRadius = 4
        layer.backgroundColor = UIColor.green.cgColor
    }

    override var intrinsicContentSize: CGSize {
        let imageSize = imageView.image?.size ?? .zero
        let textSize = label.sizeThatFits(UILayoutFittingExpandedSize)
        return CGSize(width: (imageSize.width > 0 ? imageSize.width + padding : 0) + textSize.width + padding * 2,
                      height: max(textSize.height, imageSize.height) + padding * 2)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = imageView.image?.size ?? .zero
        let textSize = label.sizeThatFits(UILayoutFittingExpandedSize)
        imageView.frame = CGRect(origin: CGPoint(x: padding,
                                                 y: (frame.height - imageSize.height) / 2),
                                 size: imageSize)
        label.frame = CGRect(origin: CGPoint(x: imageSize.width == 0 ? padding : imageView.frame.maxX + padding,
                                             y: (frame.height - textSize.height) / 2),
                             size: textSize)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

@IBDesignable
class IssueTagLabel: UILabel {
    enum IssueType: Int {
        case openIssue
        case closedIssue
        case openMerge
        case merged
        case none
    }

    @IBInspectable var typeNumer: Int = 0 {
        didSet {
            type = IssueType(rawValue: typeNumer % 4) ?? .none
        }
    }

    var type: IssueType = .none {
        didSet {
            switch type {
            case .openIssue:
                layer.backgroundColor = UIColor(hex: 0x2cbe4e).cgColor
                text = "\u{e623} Open"
            case .closedIssue:
                layer.backgroundColor = UIColor(hex: 0xcb2431).cgColor
                text = "\u{e625} Closed"
            case .openMerge:
                layer.backgroundColor = UIColor(hex: 0x2cbe4e).cgColor
                text = "\u{e896} Open"
            case .merged:
                layer.backgroundColor = UIColor(hex: 0x6f42c1).cgColor
                text = "\u{e623} Merged"
            default:
                break
            }
        }
    }

    var insets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        layer.cornerRadius = 4
        font = UIFont(name: "iconfont", size: 14)
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += insets.left + insets.right
        size.height += insets.top + insets.bottom
        return size
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
