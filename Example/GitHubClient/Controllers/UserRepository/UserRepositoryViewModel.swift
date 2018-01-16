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

class UserRepositoryViewModel {
    var ownerLogin: String? {
        didSet {
            loadUserRepos()
        }
    }

    var repositories = [Repository]()
    var layouts = [CellLayout]() {
        didSet {
            layoutsVariable.value = layouts
        }
    }
    var pagination = Pagination()
    var repositoryType: RepositoryType = .all

    var loadingTask: URLSessionTask?

    let layoutsVariable = Variable<[CellLayout]>([])
    let loadingVariable = Variable<Bool>(false)
    let errorVariable = Variable<Error?>(nil)

    func loadUserRepos() {
        guard let ownerLogin = ownerLogin else {
            return
        }
        loadingTask?.cancel()
        loadingVariable.value = true
        errorVariable.value = nil
        loadingTask = Github.shared.repos(owner: ownerLogin, success: { [weak self] (result) in
            DispatchQueue(label: "json", qos: DispatchQoS.background).async {
                self?.repositories = result
                DispatchQueue.main.async {
                    self?.layouts = result.map({ CellLayout($0) })
                    self?.loadingVariable.value = false
                }
            }
        }, failure: { [weak self] (error) in
            self?.errorVariable.value = error
            self?.loadingVariable.value = false
        })
    }
    
    func loadOrgRepos() {
        guard let ownerLogin = ownerLogin else {
            return
        }
        loadingTask?.cancel()
        loadingVariable.value = true
        errorVariable.value = nil
        loadingTask = Github.shared.repos(org: ownerLogin, success: { [weak self] (result) in
            DispatchQueue(label: "json", qos: DispatchQoS.background).async {
                self?.repositories = result
                DispatchQueue.main.async {
                    self?.layouts = result.map({ CellLayout($0) })
                    self?.loadingVariable.value = false
                }
            }
            }, failure: { [weak self] (error) in
                self?.errorVariable.value = error
                self?.loadingVariable.value = false
        })
    }
    
    func loadOwnerRepos() {
        guard let ownerLogin = ownerLogin else {
            return
        }
        loadingTask?.cancel()
        loadingVariable.value = true
        errorVariable.value = nil
        loadingTask = Github.shared.repos(org: ownerLogin, success: { [weak self] (result) in
            DispatchQueue(label: "json", qos: DispatchQoS.background).async {
                self?.repositories = result
                DispatchQueue.main.async {
                    self?.layouts = result.map({ CellLayout($0) })
                    self?.loadingVariable.value = false
                }
            }
            }, failure: { [weak self] (error) in
                self?.errorVariable.value = error
                self?.loadingVariable.value = false
        })
    }

    deinit {
        loadingTask?.cancel()
    }
}

