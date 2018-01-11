//
//  ControlButton.swift
//  GitHubClient_Example
//
//  Created by yang on 09/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable
class ControlButton: UIButton {

    let countLabel = VerticalAlignmentLabel()
    let nameLabel = VerticalAlignmentLabel()

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
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(4)
            make.left.equalTo(self).offset(4)
            make.right.equalTo(self).offset(-4)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countLabel.snp.bottom).offset(4)
            make.left.equalTo(self).offset(4)
            make.right.equalTo(self).offset(-4)
            make.bottom.equalTo(self).offset(-4)
            make.height.equalTo(countLabel.snp.height).multipliedBy(1.5)
        }
    }

    @IBInspectable var count: Int = 0 {
        didSet {
            countLabel.text = "\(count)"
            setNeedsLayout()
        }
    }

    @IBInspectable var name: String = "" {
        didSet {
            nameLabel.text = name
            setNeedsLayout()
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
