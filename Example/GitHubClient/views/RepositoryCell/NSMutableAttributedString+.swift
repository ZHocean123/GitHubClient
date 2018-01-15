//
//  NSMutableAttributedString+.swift
//  GitHubClient_Example
//
//  Created by yang on 15/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import YYText

extension NSMutableAttributedString {
    func addLink(_ tap: ((UIView, NSAttributedString, _NSRange, CGRect) -> Void)?) {
        guard string.count > 0 else {
            return
        }
        let highlight = YYTextHighlight()
        let border = YYTextBorder(fill: .gray, cornerRadius: 3)
//        border.insets = UIEdgeInsets(top: -1, left: -1, bottom: -1, right: -1)
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
