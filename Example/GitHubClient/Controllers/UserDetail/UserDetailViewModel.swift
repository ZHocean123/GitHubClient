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
    var user: User? {
        didSet {
            avatar.value = user?.avatarUrl
            name.value = user?.name ?? ""
            followers.value = user?.followers ?? 0
            following.value = user?.following ?? 0
            repos.value = user?.publicRepos ?? 0
        }
    }

    var task: URLSessionTask?
    let avatar = Variable<URL?>(nil)
    let name = Variable<String>("")
    let fullName = Variable("")
    let followers = Variable(0)
    let following = Variable(0)
    let repos = Variable(0)
    let organization = Variable("")
    let location = Variable("")
    let email = Variable("")
    let website = Variable("")

    func loadUserInfo() {
        task?.cancel()
        guard let loginName = loginName else {
            return
        }
        task = Github.shared.user(loginName, success: { [weak self] (user) in
            self?.user = user
        }) { (error) in
            log.error(error)
        }
    }

    deinit {
        task?.cancel()
    }
}
