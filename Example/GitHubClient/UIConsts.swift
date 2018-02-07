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
    static let navBgColor = UIColor(hex: 0x49616B)
    static let navTitleColor = UIColor(hex: 0xB0BEC5)
    static let navItemColor = UIColor(hex: 0x8ABEB3)
    static let appBgColor = UIColor(hex: 0x526D7A)

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

extension UIImage {
    static let clear: UIImage = {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)

        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
//        context?.setFillColor(UIColor.clear.cgColor)
//        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()

        return theImage
    }()
}
