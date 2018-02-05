//
//  ControlButton.swift
//  GitHubClient_Example
//
//  Created by yang on 09/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class ControlButton: UIButton {

    enum DisplayType: Int {
        case vertical
        case horizontal
    }

    var type: DisplayType = .vertical

    @IBInspectable var typeNumer: Int = 0 {
        didSet {
            type = DisplayType(rawValue: typeNumer % 2) ?? .vertical
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    let countLabel = VerticalAlignmentLabel()
    let nameLabel = VerticalAlignmentLabel()
    let spacing: CGFloat = 4

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
//        self.setBackgroundImage(#imageLiteral(resourceName: "btn_bg_normal"), for: .normal)
//        self.setBackgroundImage(#imageLiteral(resourceName: "btn_bg_highlight"), for: .highlighted)
        countLabel.textAlignment = .center
        countLabel.verticalAlignment = .center
        countLabel.font = UIFont.systemFont(ofSize: 12)

        nameLabel.textAlignment = .center
        nameLabel.verticalAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 14)

        addSubview(countLabel)
        addSubview(nameLabel)
    }

    override var intrinsicContentSize: CGSize {
        let countSize = countLabel.sizeThatFits(UILayoutFittingExpandedSize)
        let nameSize = nameLabel.sizeThatFits(UILayoutFittingExpandedSize)
        switch type {
        case .vertical:
            return CGSize(width: max(countSize.width, nameSize.width),
                          height: countSize.height + nameSize.height + spacing)
        case .horizontal:
            return CGSize(width: countSize.width + nameSize.width + spacing,
                          height: max(countSize.height, nameSize.height))
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let countSize = countLabel.sizeThatFits(UILayoutFittingExpandedSize)
        let nameSize = nameLabel.sizeThatFits(UILayoutFittingExpandedSize)

        switch type {
        case .vertical:
            let top = (frame.height - countSize.height - nameSize.height - spacing) / 2
            countLabel.frame = CGRect(x: (frame.width - countSize.width) / 2,
                                      y: top,
                                      width: countSize.width,
                                      height: countSize.height)
            nameLabel.frame = CGRect(x: (frame.width - nameSize.width) / 2,
                                     y: countLabel.frame.maxY + spacing,
                                     width: nameSize.width,
                                     height: nameSize.height)
        case .horizontal:
            let left = (frame.width - countSize.width - nameSize.width - spacing) / 2
            countLabel.frame = CGRect(x: left,
                                      y: (frame.height - countSize.height) / 2,
                                      width: countSize.width,
                                      height: countSize.height)
            nameLabel.frame = CGRect(x: countLabel.frame.maxX + spacing,
                                     y: (frame.height - nameSize.height) / 2,
                                     width: nameSize.width,
                                     height: nameSize.height)
        }
    }

    @IBInspectable var countNum: Int = 0 {
        didSet {
            countLabel.text = "\(countNum)"
            setNeedsLayout()
        }
    }

    @IBInspectable var name: String? {
        didSet {
            nameLabel.text = name
        }
    }

    @IBInspectable var countColor: UIColor = .black {
        didSet {
            countLabel.textColor = countColor
        }
    }

    @IBInspectable var nameColor: UIColor = .black {
        didSet {
            nameLabel.textColor = nameColor
        }
    }

    @IBInspectable var countFontSize: CGFloat = 12 {
        didSet {
            countLabel.font = UIFont.systemFont(ofSize: countFontSize)
        }
    }

    @IBInspectable var nameFontSize: CGFloat = 14 {
        didSet {
            nameLabel.font = UIFont.systemFont(ofSize: nameFontSize)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
