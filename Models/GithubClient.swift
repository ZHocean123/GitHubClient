//
//  GithubClient.swift
//  LoveGitHub
//
//  Created by yang on 26/10/2017.
//

struct GithubClient {
    let clientId: String?
    let redirectURL: String?
    var scopes: [GithubScope] = []

    var stringScopes: String {
        return scopes.map({ (scope) -> String in
            return scope.rawValue
        }).joined(separator: ",")
    }

    init(clientId: String?, redirectURL: String?) {
        self.clientId = clientId
        self.redirectURL = redirectURL
    }
}
