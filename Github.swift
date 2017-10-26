//
//  Github.swift
//  FBSnapshotTestCase
//
//  Created by yang on 26/10/2017.
//

import Foundation

public class Github {
    // MARK: - Types
    private typealias Parameters = [String: Any]

    public typealias EmptySuccessHandler = () -> Void
    public typealias SuccessHandler<T> = (_ data: T) -> Void
    public typealias FailureHandler = (_ error: GithubError) -> Void

    // MARK: - Properties
    private let urlSession = URLSession(configuration: .default)
    private let keychain = KeychainSwift()
    private let decoder = JSONDecoder()

    private var client: GithubClient?

    // MARK: - Initializers
    public static let shared = Github()

    private init() {
        if client == nil,
            let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            let clientId = dict["GithubClientId"] as? String
            let redirectURL = dict["GithubRedirectURL"] as? String
            client = GithubClient(clientId: clientId, redirectURL: redirectURL)
        }
    }

    // MARK: - Authentication

    /// Starts an authentication process.
    ///
    /// Shows a custom `UIViewController` with Github's login page.
    ///
    /// - Parameters:
    ///   - navController: navController: Your current `UINavigationController`.
    ///   - scopes: The scope of the access you are requesting from the user.
    ///   - success: The callback called after a correct login.
    ///   - failure: The callback called after an incorrect login.
    public func login(navController: UINavigationController, scopes: [GithubScope] = [], success: EmptySuccessHandler?, failure: FailureHandler?) {
        client?.scopes = scopes
        if let client = client {
            let vc = AuthViewController(client: client, success: { (accessToken) in
                if !self.keychain.set(accessToken, forKey: "accessToken") {
                    failure?(GithubError())
                } else {
                    navController.popViewController(animated: true)
                    success?()
                }
            }, failure: failure)
            navController.show(vc, sender: nil)
        } else {
            failure?(GithubError())
        }
    }

    public var isSessionValid: Bool {
        return keychain.get("accessToken") != nil
    }

    @discardableResult
    public func logout() -> Bool {
        return keychain.delete("accessToken")
    }

    // MARK: -
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }

    @discardableResult
    private func request<T: Decodable>(_ endpoint: String,
                                       method: HTTPMethod = .get,
                                       parameters: Parameters? = nil,
                                       success: SuccessHandler<T>?,
                                       failure: FailureHandler?) -> URLSessionDataTask {
        var urlRequest = URLRequest(url: buildURL(for: endpoint, withParameters: parameters))
        urlRequest.httpMethod = method.rawValue

        let task = urlSession.dataTask(with: urlRequest) { (data, respones, error) in
            if let data = data {
                DispatchQueue.global(qos: .utility).async {
                    do {
                        let object = try self.decoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            success?(object)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            failure?(GithubError())
                        }
                    }
                }
            }
        }
        task.resume()
        return task
    }

    private func buildURL(for endpoint: String, withParameters parameters: Parameters? = nil) -> URL {
        var urlComps = URLComponents(string: "https://api.github.com/" + endpoint)
        var items = [URLQueryItem]()
        let accessToken = keychain.get("accessToken")
        items.append(URLQueryItem(name: "accessToken", value: accessToken))

        parameters?.forEach({ (parameter) in
            items.append(URLQueryItem(name: parameter.key, value: "\(parameter.value)"))
        })

        urlComps!.queryItems = items

        return urlComps!.url!
    }

    // MARK: - repository

    public func search(repo query: String,
                       success: SuccessHandler<SearchRepositoryResult>?,
                       failure: FailureHandler?) {
        var parameters = Parameters()
        parameters["q"] = query
        request("search/repositories", parameters: parameters, success: success, failure: failure)
    }
}
