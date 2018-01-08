//
//  MarkDownView.swift
//  GitHubClient_Example
//
//  Created by yang on 08/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class MarkDownView: UIView {

    let webView = WKWebView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        webView.frame = self.bounds
        webView.navigationDelegate = self
        addSubview(webView)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: webView.frame.width,
                      height: webView.scrollView.contentSize.height)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension MarkDownView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        invalidateIntrinsicContentSize()
        webView.evaluateJavaScript("document.body.offsetHeight") {[weak self] (result, error) in
            if let height = result as? CGFloat {
                if var frame = self?.webView.frame {
                    frame.size.height = height
                    self?.webView.frame = frame
                    self?.invalidateIntrinsicContentSize()
                }
            }
        }
    }
}

