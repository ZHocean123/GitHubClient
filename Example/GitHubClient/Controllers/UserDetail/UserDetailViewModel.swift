//
//  UserDetailViewModel.swift
//  GitHubClient_Example
//
//  Created by yang on 15/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import GitHubClient
import RxSwift

class UserDetailViewModel {
    var loginName: String? {
        didSet {
            loadUserInfo()
        }
    }

    let userVariable = Variable<User?>(nil)
    var task: URLSessionTask?

    func loadUserInfo() {
        task?.cancel()
        guard let loginName = loginName else {
            return
        }
        task = Github.shared.user(loginName, success: { [weak self] user in
            self?.userVariable.value = user
        }, failure: { error in
            log.error(error)
        })
    }

    deinit {
        task?.cancel()
    }
}
