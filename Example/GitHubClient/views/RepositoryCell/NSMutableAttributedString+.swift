//
//  NSMutableAttributedString+.swift
//  GitHubClient_Example
//
//  Created by yang on 15/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import DynamicColor
import Foundation
import YYText

extension NSMutableAttributedString {
    func addLink(_ tap: ((UIView, NSAttributedString, _NSRange, CGRect) -> Void)?) {
        guard string.isEmpty else {
            return
        }

        yy_color = UIColor(hex: 0xB4D6FE)

        let highlight = YYTextHighlight()
        let border = YYTextBorder(fill: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8), cornerRadius: 3)
        highlight.setBackgroundBorder(border)
        highlight.tapAction = tap

        yy_setTextHighlight(highlight, range: yy_rangeOfAll())
    }

    func add(spacing: CGFloat) {
        let padding = NSMutableAttributedString(string: "\n\n")
        padding.yy_setFont(UIFont.systemFont(ofSize: spacing), range: padding.yy_rangeOfAll())
        append(padding)
    }
}
