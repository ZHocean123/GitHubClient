//
//  IssueListViewModel.swift
//  GitHubClient_Example
//
//  Created by yang on 18/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import GitHubClient
import RxSwift

enum IssueListSourceType {
    case repo(owner: String, name: String)
    case owner
    case org(org: String)
    case none
}

extension IssueListSourceType {
    var repoInfo: (owner: String, repo: String) {
        switch self {
        case let .repo(owner, name):
            return (owner, name)
        default:
            return ("", "")
        }
    }
}

class IssueListViewModel {
    let issues = Variable<[GitHubClient.Issue]>([])
    let loadingState = Variable<LoadingState>(.loaded)

    var sourceType: IssueListSourceType = .none {
        didSet {
            switch sourceType {
            case let .repo(owner, name):
                self.loadRepoIssues(owner: owner, name: name)
            case .owner:
                break
            case .org:
                break
            default:
                break
            }
        }
    }

    private var loadingTask: URLSessionTask?

    func loadRepoIssues(owner: String, name: String) {
        loadingTask?.cancel()
        loadingState.value = .loading
        loadingTask = Github.shared.issues(forRepo: name, owner: owner, success: { [weak self] result in
            self?.issues.value = result
            self?.loadingState.value = .loaded
        }, failure: { [weak self] error in
            self?.loadingState.value = .error(error: error)
        })
    }

    deinit {
        loadingTask?.cancel()
    }
}
