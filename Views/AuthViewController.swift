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

    private func setupProgressView() {
        let navBar = navigationController!.navigationBar
        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progress = 0.0
        progressView.tintColor = UIColor(red: 0.88, green: 0.19, blue: 0.42, alpha: 1.0)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        navBar.addSubview(progressView)

        if #available(iOS 9.0, *) {
            let bottomConstraint = navBar.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 1)
            let leftConstraint = navBar.leadingAnchor.constraint(equalTo: progressView.leadingAnchor)
            let rightConstraint = navBar.trailingAnchor.constraint(equalTo: progressView.trailingAnchor)
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
        guard let url = navigationAction.request.url else {
            return
        }
        print("action url:" + (url.absoluteString))
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            components.path == "/github_callbak" {
            var code: String
            for queryItem in components.queryItems ?? [] where queryItem.name == "code" {
                if let value = queryItem.value {
                    code = value
                    print("code:" + code)
                    getAccessToken(String(code))
                } else {
                    print("emptyCode")
                }
                break
            }
            return
        }

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let httpResponse = navigationResponse.response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 400:
                decisionHandler(.cancel)
                DispatchQueue.main.async {
                    self.failure?(GithubError())
                }
            default:
                break
            }
        }
        decisionHandler(.allow)
    }
}

extension AuthViewController {
    private func getAccessToken(_ code: String) {
//        disposeBag = DisposeBag()
//        GithubAuthPrvider.rx.request(.oAuth(client_id: clientId, client_secret: client_secret, code: code)).mapString().subscribe { [weak self] (event) in
//            switch event {
//            case .success(let str):
//                var params = [String: String]()
//                let valueStrs = str.split(separator: "&")
//                for valueStr in valueStrs {
//                    let array = valueStr.split(separator: "=")
//                    let key = array.count > 0 ? String(array[0]) : ""
//                    let value = array.count > 1 ? String(array[1]) : ""
//                    params[key] = value
//                }
//                print(params)
//                if let accessToken = params["access_token"] {
//                    if let strongSelf = self, !strongSelf.keychain.set(accessToken, forKey: "accessToken") {
//
//                    } else {
//                        self?.dismiss(animated: true, completion: {
//
//                        })
//                    }
//                    Defaults.shared.set(accessToken, for: accessTokenKey)
//                }
//            case .error(let error):
//                print(error)
//            }
//        }.disposed(by: disposeBag)
    }
}
