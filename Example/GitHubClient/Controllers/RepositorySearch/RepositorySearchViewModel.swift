//
//  RepositorySearchViewModel.swift
//  GitHubClient_Example
//
//  Created by yang on 04/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import GitHubClient
import RxSwift

class RepositorySearchViewModel {
    var repositories = [Repository]()
    var layouts = [CellLayout]()
    var pagination = Pagination()

    func search(key: String) -> Observable<Any> {
        return Observable.create({ observer in
            let task = Github.shared.search(repo: key, success: { [weak self] result in
                DispatchQueue(label: "json", qos: DispatchQoS.background).async {
                    self?.repositories = result.items
                    DispatchQueue.main.async {
                        self?.layouts = result.items.map({ CellLayout($0) })
                        observer.on(.next(true))
                        observer.on(.completed)
                    }
                }
            }, failure: { error in
                observer.on(.error(error))
            })
            return Disposables.create(with: task.cancel)
        })
    }
}
