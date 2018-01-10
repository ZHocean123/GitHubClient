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
    var repo: Repository

    private var languagesTask: URLSessionTask?
    private var tagsTask: URLSessionTask?
    private var topicsTask: URLSessionTask?

    var languages: [String: Int] = [:]
    var topics: [String] = []

    let languagesObserver: Observable<[String: Int]>
    let topicsObserver: Observable<[String]>
    
    init(_ repo: Repository) {
        self.repo = repo
        languagesObserver = Observable.just(languages)
        topicsObserver = Observable.just(topics)
    }

    func loadRepoLanguages() {
        languagesTask?.cancel()
        languagesTask = Github.shared.languages(owner: repo.owner.login, repo: repo.name, success: { [weak self] (languages) in
            self?.languages = languages
        }) { (error) in
            print(error)
        }
    }

    func loadRepoTopics() {
        topicsTask?.cancel()
        topicsTask = Github.shared.topics(owner: repo.owner.login, repo: repo.name, success: { [weak self] (topics) in
            self?.topics = topics.names
        }) { (error) in
            print(error)
        }
    }

    func loadRepoTags() {
        tagsTask?.cancel()
//        tagsTask = Github.shared.tags(owner: repo.owner.login, repo: repo.name, success: { (<#[String: Int]#>) in
//            <#code#>
//        }) { (error) in
//            print(error)
//        }
    }

    deinit {
        languagesTask?.cancel()
        tagsTask?.cancel()
        topicsTask?.cancel()
    }
}

