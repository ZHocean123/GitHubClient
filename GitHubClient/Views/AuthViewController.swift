//
//  AuthViewController.swift
//  MyGithub
//
//  Created by yang on 10/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {

    // MARK - Types
    typealias SuccessHandler = (_ accessToken: String) -> Void
    typealias FailureHandler = (_ error: GithubError) -> Void

    // MARK: - Properties
    private var client: GithubClient
    private var success: SuccessHandler?
    private var failure: FailureHandler?

    private var progressView: UIProgressView!
    private var webViewObservation: NSKeyValueObservation!
    private var state = ""
    private let urlSession = URLSession(configuration: .default)
    private var task: URLSessionDataTask?

    // MARK - Initializers
    init(client: GithubClient, success: SuccessHandler?, failure: FailureHandler?) {
        self.client = client
        self.success = success
        self.failure = failure
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initializes progress view
        setupProgressView()

        // Initializes web view
        let webView = setupWebView()

        // Starts authorization
        loadAuthorizationURL(webView: webView)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        progressView.removeFromSuperview()

        webViewObservation.invalidate()
    }

    private func setupProgressView() {
        let navBar = navigationController!.navigationBar
        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progress = 0.0
        progressView.tintColor = UIColor(red: 0.88, green: 0.19, blue: 0.42, alpha: 1.0)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        navBar.addSubview(progressView)

        if #available(iOS 9.0, *) {
            let bottomConstraint = progressView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -1)
            let leftConstraint = progressView.leadingAnchor.constraint(equalTo: navBar.leadingAnchor)
            let rightConstraint = progressView.trailingAnchor.constraint(equalTo: navBar.trailingAnchor)
            NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint])
        } else {
            // Fallback on earlier versions
        }
    }

    private func setupWebView() -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        if #available(iOS 9.0, *) {
            webConfiguration.websiteDataStore = .nonPersistent()
        }

        let webView = WKWebView(frame: view.frame, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self

        webViewObservation = webView.observe(\.estimatedProgress, changeHandler: progressViewChangeHandler)

        view.addSubview(webView)

        return webView
    }

    private func progressViewChangeHandler<Value>(webView: WKWebView, change: NSKeyValueObservedChange<Value>) {
        progressView.alpha = 1.0
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)

        if webView.estimatedProgress >= 1.0 {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.progressView.alpha = 0.0
            }, completion: { (_ finished) in
                self.progressView.progress = 0
            })
        }
    }

    // MARK: -

    private func loadAuthorizationURL(webView: WKWebView) {
        // set state
        state = "13123"

        // load url
        var components = URLComponents(string: "https://github.com/login/oauth/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: client.clientId),
            URLQueryItem(name: "redirect_uri", value: client.redirectURL),
            URLQueryItem(name: "scope", value: client.stringScopes),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "allow_signup", value: "true")
        ]
        webView.load(URLRequest(url: components.url!,
                                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeController(_ sender: Any) {
        dismiss(animated: true) {

        }
    }
}


// MARK: - WKNavigationDelegate
extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navigationItem.title = webView.title
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let redirectComponents = URLComponents(url: URL(string: client.redirectURL ?? "")!, resolvingAgainstBaseURL: false),
            components.path == redirectComponents.path {
            decisionHandler(.cancel)
            var code: String
            for queryItem in components.queryItems ?? [] where queryItem.name == "code" {
                if let value = queryItem.value {
                    code = value
                    print("code:" + code)
                    DispatchQueue.main.async { [weak self] in
                        self?.getAccessToken(String(code))
                    }
                } else {
                    print("emptyCode")
                }
                break
            }
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let httpResponse = navigationResponse.response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 400:
                decisionHandler(.cancel)
                DispatchQueue.main.async {
                    self.failure?(GithubError(kind: .invalidRequest, message: "Invalid request"))
                }
            default:
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}

extension AuthViewController {
    private func getAccessToken(_ code: String) {

        var urlRequest = URLRequest(url: URL(string: "https://github.com/login/oauth/access_token")!)
        urlRequest.httpMethod = "POST"
        let params = [
            "client_id": client.clientId ?? "",
            "client_secret": Github.clientSecret,
            "code": code
        ]
        let paramStr = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        urlRequest.httpBody = paramStr.data(using: .utf8)
        urlRequest.httpShouldHandleCookies = true
        var allHTTPHeaderFields = urlRequest.allHTTPHeaderFields ?? [String: String]()
        allHTTPHeaderFields["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        urlRequest.allHTTPHeaderFields = allHTTPHeaderFields
        task = urlSession.dataTask(with: urlRequest) { [weak self] (data, respones, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.failure?(GithubError(kind: .invalidRequest, message: error.localizedDescription))
                }
            }
            if let data = data, let str = String(data: data, encoding: .utf8) {
                DispatchQueue.global(qos: .utility).async {
                    var params = [String: String]()
                    let valueStrs = str.split(separator: "&")
                    for valueStr in valueStrs {
                        let array = valueStr.split(separator: "=")
                        let key = array.count > 0 ? String(array[0]) : ""
                        let value = array.count > 1 ? String(array[1]) : ""
                        params[key] = value
                    }
                    if let accessToken = params["access_token"] {
                        DispatchQueue.main.async {
                            self?.success?(accessToken)
                        }
                        return
                    }
                }
            }
            DispatchQueue.main.async {
                self?.failure?(GithubError(kind: .invalidRequest, message: "no response data"))
            }
        }
        task?.resume()
    }
}
