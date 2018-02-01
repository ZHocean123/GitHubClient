//
//  IssueDetailViewModel.swift
//  GitHubClient_Example
//
//  Created by yang on 18/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import GitHubClient
import RxSwift

final class IssueDetailViewModel {
    var repo: String?
    var owner: String?
    var number: Int?

    var comments = Variable<[IssueCommontCellViewModel]>([])

    private var loadTask: URLSessionTask?
    private var commentsTask: URLSessionTask?

    func loadComments() {
        guard let repo = repo, let owner = owner, let number = number else {
            return
        }

        commentsTask?.cancel()
        commentsTask = Github.shared.issueComments(forRepo: repo,
                                                   owner: owner,
                                                   number: number,
                                                   success: { [weak self] comments in
                                                       self?.comments.value = comments.map({ IssueCommontCellViewModel($0) })
                                                   }, failure: { error in
                                                       log.error(error)
                                                   })
    }

    deinit {
        loadTask?.cancel()
        commentsTask?.cancel()
    }
}
