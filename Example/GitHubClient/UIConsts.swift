//
//  UIConsts.swift
//  GitHubClient_Example
//
//  Created by ocean zhang on 30/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DynamicColor
import UIKit

extension UIColor {
    static let normalColor = UIColor(hex: 0x000000)
    static let linkColor = UIColor(hex: 0x0366d6)
    static let commitColor = UIColor(hex: 0x586069)
    static let openColor = UIColor(hex: 0x2cbe4e)
    static let closeColor = UIColor(hex: 0xcb2431)
    static let mergedColor = UIColor(hex: 0x6f42c1)
    static let alphaBgColor = UIColor(hex: 0x000000).withAlphaComponent(0.15)
}

extension UIFont {
    static let semiboldFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
    static let regularFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let smallregularFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    static let issueStatusFont = UIFont(name: "iconfont", size: 14)
}
