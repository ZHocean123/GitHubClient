//
//  TopicsView.swift
//  GitHubClient_Example
//
//  Created by yang on 08/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class TopicsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
        commonInit()
    }

    func commonInit() {
        setupSubviews()
    }

    func setupSubviews() {

        let cha = subviews.count - topics.count
        if cha > 0 {
            for _ in 0..<cha {
                subviews.last?.removeFromSuperview()
            }
        } else if cha < 0 {
            for _ in cha..<0 {
                addSubview(TopicLabel())
            }
        }

        for index in 0..<topics.count {
            let label = subviews[index] as? TopicLabel
            label?.text = topics[index]
        }

        layoutTopicLabels()
    }

    @IBInspectable var topics: [String] = ["topic"] {
        didSet {
            setupSubviews()
        }
    }

    @IBInspectable var padding: CGFloat = 4 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var spacing: CGFloat = 4 {
        didSet {
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        get {
            var newSize = CGSize(width: self.frame.width,
                                 height: 0)
            if let lastview = subviews.last {
                newSize.height = lastview.frame.maxY + padding
            }
            return newSize
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTopicLabels()
    }

    func layoutTopicLabels() {
        let size = CGSize(width: frame.width - padding * 2,
                          height: 999)
        var preView: UIView? = nil
        for subview in subviews {
            let subviewSize = subview.sizeThatFits(size)
            if let preView = preView {
                if preView.frame.maxX + spacing + subviewSize.width + padding > frame.width {
                    //新起一行
                    subview.frame = CGRect(x: padding,
                                           y: preView.frame.maxY + spacing,
                                           width: subviewSize.width,
                                           height: subviewSize.height)
                } else {
                    //同一行
                    subview.frame = CGRect(x: preView.frame.maxX + spacing,
                                           y: preView.frame.minY,
                                           width: subviewSize.width,
                                           height: subviewSize.height)
                }
            } else {
                subview.frame = CGRect(x: padding,
                                       y: padding,
                                       width: subviewSize.width,
                                       height: subviewSize.height)
            }
            preView = subview
        }
        invalidateIntrinsicContentSize()
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
class TopicLabel: UILabel {

    @IBInspectable var padding: CGFloat = 4 {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 12)
        backgroundColor = UIColor(hex: 0xe7f3ff)
        textColor = UIColor(hex: 0x0366d6)
        layer.cornerRadius = 3
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width + padding, height: super.intrinsicContentSize.height + padding)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.width += padding * 2
        newSize.height += padding * 2
        return newSize
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: padding, dy: padding))
    }
}
