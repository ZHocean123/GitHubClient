//
//  LanguageBar.swift
//  GitHubClient_Example
//
//  Created by yang on 10/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DynamicColor

class LanguageBar: UIView {
    struct LanguageInfo {
        let name: String
        let number: Int
        let percent: CGFloat
        let color: UIColor
    }

    var languages: [String: Int] = [:] {
        didSet {
            totalCount = languages.reduce(0) { (pre, element) in
                let (_, value) = element
                return pre + value
            }
            list = languages.map { (element) in
                let (key, value) = element
                return LanguageInfo(name: key,
                                    number: value,
                                    percent: totalCount == 0 ? 0 : CGFloat(value) / CGFloat(totalCount),
                                    color: UIColor(hex: colorSchemes[key] ?? otherColor))
                }.sorted(by: { $0.number > $1.number })
            setupSubViews()
        }
    }

    private var totalCount: Int = 0
    private var list: [LanguageInfo] = []

    func setupSubViews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
        list.forEach { (info) in
            let label = UILabel()
            label.backgroundColor = info.color
            addSubview(label)
        }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var lastOriginX: CGFloat = 0
        for (index, view) in subviews.enumerated() {
            guard index < list.count, let label = view as? UILabel else {
                return
            }
            label.frame = CGRect(x: lastOriginX,
                                 y: 0,
                                 width: bounds.width * list[index].percent,
                                 height: bounds.height)
            lastOriginX = label.frame.maxX
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

let otherColor: UInt32 = 0xededed
let colorSchemes: [String: UInt32] = [
    "C": 0x555555,
    "C++": 0xf34b7d,
    "Python": 0x3572A5,
    "JavaScript": 0xf1e05a,
    "PHP": 0x4F5D95,
    "Shell": 0x89e051,
    "Go": 0x375eab,
    "Kotlin": 0xF18E33,
    "Objective-C": 0x438eff,
    "Swift": 0xffac45,
    "Vue": 0x2c3e50,
    "C#": 0x178600,
    "TypeScript": 0x2b7489,
    "CSS": 0x563d7c,
    "other": otherColor
]

