//
//  RepositoryDetailViewModel.swift
//  GitHubClient_Example
//
//  Created by yang on 10/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import GitHubClient
import RxSwift

class RepositoryDetailViewModel {
    var repo: Repository? {
        didSet {
            languages.value = [:]
            topics.value = []
            repository.value = repo
            if repo != nil {
                loadRepoDetails()
            }
        }
    }

    private var languagesTask: URLSessionTask?
    private var tagsTask: URLSessionTask?
    private var topicsTask: URLSessionTask?

    let repository: Variable<Repository?> = Variable(nil)
    let languages: Variable<[String: Int]> = Variable([:])
    let topics: Variable<[String]> = Variable([])

    func loadRepoDetails() {
        loadRepoLanguages()
        loadRepoTopics()
    }

    func loadRepoLanguages() {
        languagesTask?.cancel()
        guard let repo = repo else { return }
        languagesTask = Github.shared.languages(owner: repo.owner.login, repo: repo.name, success: { [weak self] (languages) in
            self?.languages.value = languages
            log.debug(languages)
        }) { (error) in
            log.error(error)
        }
    }

    func loadRepoTopics() {
        topicsTask?.cancel()
        guard let repo = repo else { return }
        topicsTask = Github.shared.topics(owner: repo.owner.login, repo: repo.name, success: { [weak self] (topics) in
            self?.topics.value = topics.names
            log.debug(topics.names)
        }) { (error) in
            log.error(error)
        }
    }

    func loadRepoTags() {
        tagsTask?.cancel()
        guard let repo = repo else { return }
//        tagsTask = Github.shared.tags(owner: repo.owner.login, repo: repo.name, success: { (<#[String: Int]#>) in
//            <#code#>
//        }) { (error) in
//            log.error(error)
//        }
    }

    deinit {
        languagesTask?.cancel()
        tagsTask?.cancel()
        topicsTask?.cancel()
    }
}

