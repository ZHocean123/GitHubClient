//
//  UserRepositoryViewModel.swift
//  GitHubClient_Example
//
//  Created by yang on 05/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import GitHubClient
import RxSwift

enum LoadingState {
    case loading
    case error(error: Error)
    case loaded
}

class RepositoryListViewModel {

    lazy var ownerRepositoryTypes: [RepositoryType] = {
        return [.all, .public, .private]
    }()

    lazy var userRepositoryTypes: [RepositoryType] = {
        return [.all, .public, .private, .member, .owner]
    }()

    let repositoryTypesVariable = Variable<[RepositoryType]>([])

    enum SourceType {
        case user(username: String)
        case owner
        case org(org: String)
        case none
    }

    var sourceType: SourceType = .none {
        didSet {
            switch sourceType {
            case .user:
                repositoryTypesVariable.value = userRepositoryTypes
            case .owner:
                repositoryTypesVariable.value = ownerRepositoryTypes
            case .org:
                repositoryTypesVariable.value = []
            default:
                repositoryTypesVariable.value = []
            }
            load()
        }
    }

    private var ownerLogin: String?
    private var orgName: String?

    var repositories = [Repository]()
    var pagination = Pagination()
    var repositoryType: RepositoryType = .all {
        didSet {
            load()
        }
    }

    var loadingTask: URLSessionTask?

    let layoutList = Variable<[CellLayout]>([])
    let loadingState = Variable<LoadingState>(.loaded)

    func load() {
        switch sourceType {
        case .user(let username):
            ownerLogin = username
            loadUserRepos()
        case .owner:
            loadOwnerRepos()
        case .org(let org):
            orgName = org
            loadOrgRepos()
        default:
            break
        }
    }

    func loadUserRepos() {
        guard let ownerLogin = ownerLogin else {
            return
        }
        loadingTask?.cancel()
        loadingState.value = .loading
        loadingTask = Github.shared.repos(owner: ownerLogin, success: { [weak self] (result) in
            DispatchQueue(label: "json", qos: DispatchQoS.background).async {
                self?.repositories = result
                DispatchQueue.main.async {
                    self?.layoutList.value = result.map({ CellLayout($0) })
                    self?.loadingState.value = .loaded
                }
            }
        }, failure: { [weak self] (error) in
            self?.loadingState.value = .error(error: error)
        })
    }

    func loadOrgRepos() {
        guard let ownerLogin = ownerLogin else {
            return
        }
        loadingTask?.cancel()
        loadingState.value = .loading
        loadingTask = Github.shared.repos(org: ownerLogin, success: { [weak self] (result) in
            DispatchQueue(label: "json", qos: DispatchQoS.background).async {
                self?.repositories = result
                DispatchQueue.main.async {
                    self?.layoutList.value = result.map({ CellLayout($0) })
                    self?.loadingState.value = .loaded
                }
            }
        }, failure: { [weak self] (error) in
            self?.loadingState.value = .error(error: error)
        })
    }

    func loadOwnerRepos() {
        loadingTask?.cancel()
        loadingState.value = .loading
        loadingTask = Github.shared.user(type: self.repositoryType, success: { [weak self] (result) in
            DispatchQueue(label: "json", qos: DispatchQoS.background).async {
                self?.repositories = result
                let layouts = result.map({ CellLayout($0) })
                DispatchQueue.main.async {
                    self?.layoutList.value = layouts
                    self?.loadingState.value = .loaded
                }
            }
        }, failure: { [weak self] (error) in
            self?.loadingState.value = .error(error: error)
        })
    }

    deinit {
        loadingTask?.cancel()
    }
}

extension RepositoryType: MenuOption {
    var title: String {
        return self.rawValue
    }
}
