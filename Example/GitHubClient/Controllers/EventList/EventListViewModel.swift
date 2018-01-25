//
//  EventListViewModel.swift
//  GitHubClient_Example
//
//  Created by yang on 22/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import GitHubClient
import RxSwift

class EventListViewModel {
    let layoutList = Variable<[EventViewModel]>([])
    let loadingState = Variable<LoadingState>(.loaded)

    var loadingTask: URLSessionTask?

    func loadEvents() {
        loadingTask?.cancel()
        loadingState.value = .loading
        loadingTask = Github.shared.events("ZHocean123", success: { [weak self] result in
            DispatchQueue.global(qos: .utility).async {
                let models = result.filter({ event -> Bool in
                    switch event.type {
                    case .issuesEvent, .issueCommentEvent:
                        return false
                    default:
                        return true
                    }
                }).map({ EventViewModel($0) })
                DispatchQueue.main.async {
                    self?.layoutList.value = models
                    self?.loadingState.value = .loaded
                }
            }
        }, failure: { [weak self] error in
            self?.loadingState.value = .error(error: error)
        })
    }

    deinit {
        loadingTask?.cancel()
    }
}
