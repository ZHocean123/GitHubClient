//
//  ReadMeView.swift
//  GitHubClient_Example
//
//  Created by yang on 08/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import EFMarkdown
import UIKit
import WebKit

protocol ReadMeViewDelegate: class {
    func heightDidChange(_ height: CGFloat)
}

class ReadMeView: UIView {

    let loadingBgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .alphaBgColor
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

    weak var delegate: ReadMeViewDelegate?

    var isLoading: Bool = false {
        didSet {
            loadingBgView.isHidden = !isLoading
            if isLoading {
                indicatorView.startAnimating()
            } else {
                indicatorView.startAnimating()
            }
            invalidateIntrinsicContentSize()
        }
    }

    private var observation: NSKeyValueObservation?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = self
        webView.frame = self.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(webView)

        addSubview(loadingBgView)
        loadingBgView.addSubview(indicatorView)

        observation = webView.scrollView.observe(\.contentSize) { [weak self] scrollView, _ in
            if self?.frame.height != scrollView.contentSize.height {
//                self?.invalidateIntrinsicContentSize()
//                self?.delegate?.heightDidChange(scrollView.contentSize.height)
            }
        }
    }

    deinit {
        session.invalidateAndCancel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = bounds
        loadingBgView.frame = bounds
        indicatorView.center = CGPoint(x: bounds.midX, y: bounds.midY)
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
        let task = session.dataTask(with: readMeRequest) { [weak self] data, _, error in
            if error == nil, let data = data, let markDown = String(data: data, encoding: .utf8) {
                do {
                    let markdownHTML = try EFMarkdown().markdownToHTML(markDown)
                    let templateURL = Bundle.main.url(forResource: "index", withExtension: "html")!
                    let templateContent = try String(contentsOf: templateURL, encoding: String.Encoding.utf8)
                    let htmlStr = templateContent.replacingOccurrences(of: "$PLACEHOLDER", with: markdownHTML)
                    DispatchQueue.main.async {
                        self?.webView.loadHTMLString(htmlStr,
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
        webView.evaluateJavaScript("document.body.offsetHeight") { [weak self] (result, _) in
            if let height = result as? CGFloat {
                if var frame = self?.webView.frame {
                    frame.size.height = height
                    self?.webView.scrollView.contentSize = frame.size
                    self?.invalidateIntrinsicContentSize()
                    self?.delegate?.heightDidChange(height)
                }
            }
        }
    }
}
