//
//  NSMutableAttributedString+.swift
//  GitHubClient_Example
//
//  Created by yang on 15/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import YYText
import DynamicColor

extension NSMutableAttributedString {
    func addLink(_ tap: ((UIView, NSAttributedString, _NSRange, CGRect) -> Void)?) {
        guard string.count > 0 else {
            return
        }
        
        yy_color = UIColor(hex: 0xB4D6FE)
        
        let highlight = YYTextHighlight()
        let border = YYTextBorder(fill: UIColor(white: 1, alpha: 0.15), cornerRadius: 3)
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
