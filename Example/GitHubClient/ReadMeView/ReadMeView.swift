//
//  ReadMeView.swift
//  GitHubClient_Example
//
//  Created by yang on 08/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import WebKit
import EFMarkdown

@objcMembers class ReadMeView: UIView {

    let loadingBgView:UIView = {
        let bgView = UIView()
//        bgView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return bgView
    }()
    let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.activityIndicatorViewStyle = .gray
        indicatorView.autoresizingMask = []
        return indicatorView
    }()
    
    let webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
    let session = URLSession(configuration: .default)
    var sessionTask: URLSessionTask?

    var isLoading: Bool = false {
        didSet {
            if isLoading {
                addSubview(loadingBgView)
                loadingBgView.frame = bounds
                indicatorView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
                indicatorView.startAnimating()
            } else {
                indicatorView.stopAnimating()
                loadingBgView.removeFromSuperview()
            }
            invalidateIntrinsicContentSize()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        webView.navigationDelegate = self
        webView.frame = self.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(webView)

        addObserver(self, forKeyPath: "webView.scrollView.contentSize", options: .new, context: nil)
        
        loadingBgView.addSubview(indicatorView)
    }

    deinit {
        removeObserver(self, forKeyPath: "webView.scrollView.contentSize")
        session.invalidateAndCancel()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let change = change, keyPath == "webView.scrollView.contentSize" {
            if let newSize = change[NSKeyValueChangeKey.newKey] as? NSValue {
                if self.frame.height != newSize.cgSizeValue.height {
                    invalidateIntrinsicContentSize()
                }
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: webView.frame.width,
                      height: isLoading ? 100 : webView.scrollView.contentSize.height)
    }

    func loadReadMe(url: String?) {
        sessionTask?.cancel()
        guard let url = url else {
            return
        }
        isLoading = true
        let readMeRequest = URLRequest(url: URL(string: url)!)
        let task = session.dataTask(with: readMeRequest) { [weak self] (data, response, error) in
            if error == nil, let data = data, let markDown = String(data: data, encoding: .utf8) {
                do {
                    let markdownHTML = try EFMarkdown().markdownToHTML(markDown)
                    let templateURL = Bundle.main.url(forResource: "index", withExtension: "html")!
                    let templateContent = try String(contentsOf: templateURL, encoding: String.Encoding.utf8)
                    let html = """
                    <html lang=\"en\">
                        <head>
                            <meta name=\"viewport\" content=\"initial-scale=1.0,user-scalable=no,maximum-scale=1,width=device-width\">
                        </head>
                        <body>
                            \(markdownHTML)
                        </body>
                    </html>
                    """
                    DispatchQueue.main.async {
                        self?.webView.loadHTMLString(templateContent.replacingOccurrences(of: "$PLACEHOLDER", with: markdownHTML),
                                                     baseURL: templateURL)
                    }
                } catch let error {
                    log.error(error)
                    DispatchQueue.main.async {
                        self?.isLoading = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }
        task.resume()
        sessionTask = task
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension ReadMeView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isLoading = false
//        invalidateIntrinsicContentSize()
//        webView.evaluateJavaScript("document.body.offsetHeight") { [weak self] (result, error) in
//            if let height = result as? CGFloat {
//                if var frame = self?.webView.frame {
//                    frame.size.height = height
//                    self?.webView.frame = frame
//                    self?.invalidateIntrinsicContentSize()
//                }
//            }
//        }
    }
}

