//
//  mainFlow.swift
//  GitHubClient_Example
//
//  Created by yang on 04/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import RxFlow
import RxSwift

class MainFlow: Flow {
    var root: UIViewController {
        return self.rootViewController
    }

    private let rootViewController: UINavigationController

    init() {
        self.rootViewController = UINavigationController()
    }

    func navigate(to step: Step) -> [Flowable] {
        guard let step = step as? AppStep else {
            return Flowable.noFlow
        }
        switch step {
        case .home:
            return Flowable.noFlow
        case .repoPicked(let repo):
            let detailViewController = RepositoryDetailViewController()
            detailViewController.repository = repo
            rootViewController.pushViewController(detailViewController, animated: true)
            return [Flowable(nextPresentable: detailViewController, nextStepper: nil)]
        default:
            return Flowable.noFlow
        }
    }
}
