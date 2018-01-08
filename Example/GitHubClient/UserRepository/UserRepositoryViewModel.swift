//
//  UserRepositoryViewModel.swift
//  GitHubClient_Example
//
//  Created by yang on 05/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import GitHubClient
import RxFlow
import RxSwift

class UserRepositoryViewModel: Stepper {
    var repositories = [Repository]()
    var layouts = [CellLayout]()
    var pagination = Pagination()
    var repositoryType: RepositoryType = .all

    func fetch() -> Observable<Any> {
        return Observable.create({ observer in
            let task = Github.shared.user(type: self.repositoryType, success: { [weak self] (result) in
                DispatchQueue(label: "json", qos: DispatchQoS.background).async {
                    self?.repositories = result
                    DispatchQueue.main.async {
                        self?.layouts = result.map({ CellLayout($0) })
                        observer.on(.next(true))
                        observer.on(.completed)
                    }
                }
            }, failure: { (error) in
                observer.on(.error(error))
            })
            return Disposables.create(with: task.cancel)
        })
    }

    func pick(repository: Repository) {
        self.step.onNext(AppStep.repoPicked(with: repository))
    }
}

