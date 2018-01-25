//
//  NotificationListViewModel.swift
//  GitHubClient_Example
//
//  Created by yang on 18/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import GitHubClient
import RxSwift

class NotificationListViewModel {
    let notifications = Variable<[GitHubClient.Notification]>([])
    let loadingState = Variable<LoadingState>(.loaded)

    private var loadingTask: URLSessionTask?

    func loadNotifications() {
        loadingTask?.cancel()
        loadingState.value = .loading
        loadingTask = Github.shared.notifications(success: { [weak self] result in
            self?.notifications.value = result
            self?.loadingState.value = .loaded
        }, failure: { [weak self] error in
            self?.loadingState.value = .error(error: error)
        })
    }

    deinit {
        loadingTask?.cancel()
    }
}
