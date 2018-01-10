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

    public static var clientSecret: String = ""

    private var client: GithubClient?

    private let baseUrl = "https://api.github.com/"

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
    public func login(navController: UINavigationController, scopes: [GithubScope] = [.user, .repo, .notifications], success: EmptySuccessHandler?, failure: FailureHandler?) {
        client?.scopes = scopes
        if let client = client {
            let vc = AuthViewController(client: client, success: { (accessToken) in
                if !self.keychain.set(accessToken, forKey: "accessToken") {
                    failure?(GithubError(kind: .keychainError(code: self.keychain.lastResultCode), message: "Error storing access token into keychain."))
                } else {
                    navController.popViewController(animated: true)
                    success?()
                }
            }, failure: failure)
            navController.show(vc, sender: nil)
        } else {
            failure?(GithubError(kind: .missingClient, message: "Github Client not provided. please set in info.plist"))
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
        let urlRequest = buildRequest(for: endpoint, withParameters: parameters, method: method)

        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    failure?(GithubError(kind: .netError(error: error), message: error.localizedDescription))
                }
                return
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 401:
                    DispatchQueue.main.async {
                        failure?(GithubError(kind: .oauthError, message: "Bad credentials"))
                    }
                    return
                case 200:
                    break
                default:
                    DispatchQueue.main.async {
                        failure?(GithubError(kind: .codeError(code: response.statusCode), message: "codeError"))
                    }
                    return
                }
            }
            if let data = data {
                DispatchQueue.global(qos: .utility).async {
//                    print(String(data: data, encoding: .utf8) ?? "no string data")
                    // TODO: custom error

                    // decode object
                    do {
                        let object = try self.decoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            success?(object)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            failure?(GithubError(kind: .jsonParseError(error: error), message: error.localizedDescription))
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

    private func buildRequest(for endpoint: String,
                              withParameters parameters: Parameters? = nil,
                              method: HTTPMethod) -> URLRequest {
        var headerFields = ["Authorization": "token \(keychain.get("accessToken") ?? "")", "Accept": "application/vnd.github.mercy-preview+json"]
        switch method {
        case .get:
            var urlComps = URLComponents(string: baseUrl + endpoint)!
            var items = [URLQueryItem]()
            let accessToken = keychain.get("accessToken")
            items.append(URLQueryItem(name: "accessToken", value: accessToken))

            parameters?.forEach({ (parameter) in
                items.append(URLQueryItem(name: parameter.key, value: "\(parameter.value)"))
            })

            urlComps.queryItems = items
            var request = URLRequest(url: urlComps.url!)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headerFields
            return request
        case .post:
            var request = URLRequest(url: URL(string: baseUrl + endpoint)!)
            request.httpMethod = method.rawValue
            headerFields["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
            request.allHTTPHeaderFields = headerFields
            request.httpBody = parameters?.map { "\($0.key)=\($0.value)" }
                .joined(separator: "&").data(using: .utf8)
            return request
        default:
            return URLRequest(url: URL(string: baseUrl + endpoint)!)
        }
    }

    // MARK: - repository

    public func search(repo query: String,
                       success: SuccessHandler<SearchRepositoryResult>?,
                       failure: FailureHandler?) -> URLSessionTask {
        var parameters = Parameters()
        parameters["q"] = query
        return request("search/repositories", parameters: parameters, success: success, failure: failure)
    }

    public func user(repos visibility: RepositoryVisibility? = nil,
                     affiliation: RepositoryAffiliation? = nil,
                     type: RepositoryType? = nil,
                     sort: RepositorySortType? = nil,
                     direction: RepositoryDirection? = nil,
                     success: SuccessHandler<[Repository]>?,
                     failure: FailureHandler?) -> URLSessionTask {
        var parameters = Parameters()
        parameters["visibility"] = visibility?.rawValue
        parameters["affiliation"] = affiliation?.stringValue
        parameters["type"] = type?.rawValue
        parameters["sort"] = sort?.rawValue
        parameters["direction"] = direction?.rawValue
        return request("user/repos", parameters: parameters, success: success, failure: failure)
    }

    public func tags(owner: String,
                     repo: String,
                     success: SuccessHandler<[String: Int]>?,
                     failure: FailureHandler?) -> URLSessionTask {
        return request("repos/\(owner)/\(repo)/tags", success: success, failure: failure)
    }

    public func languages(owner: String,
                          repo: String,
                          success: SuccessHandler<[String: Int]>?,
                          failure: FailureHandler?) -> URLSessionTask {
        return request("repos/\(owner)/\(repo)/languages", success: success, failure: failure)
    }

    public struct Topics: Codable {
        public let names: [String]
    }
    public func topics(owner: String,
                       repo: String,
                       success: SuccessHandler<Topics>?,
                       failure: FailureHandler?) -> URLSessionTask {
        return request("repos/\(owner)/\(repo)/topics", success: success, failure: failure)
    }

    // MARK: - activities
    public func events(_ username: String,
                       success: SuccessHandler<[Event]>?,
                       failure: FailureHandler?) -> URLSessionTask {
        var parameters = Parameters()
        return request("users/\(username)/received_events", parameters: parameters, success: success, failure: failure)
    }

    // MARK: - notifications
    public func notifications(success: SuccessHandler<[Notification]>?,
                              failure: FailureHandler?) -> URLSessionTask {
        var parameters = Parameters()
        parameters["all"] = true
        return request("notifications", parameters: parameters, success: success, failure: failure)
    }
}

public extension Repository {
    public var readMeUrlStr: String {
        return "https://raw.githubusercontent.com/\(self.owner.login)/\(self.name)/\(self.defaultBranch)/README.md"
    }
}
