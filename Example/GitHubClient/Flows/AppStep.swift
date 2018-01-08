//
//  SearchStep.swift
//  GitHubClient_Example
//
//  Created by yang on 04/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import RxFlow
import GitHubClient

enum AppStep: Step {
    case home
    case repoPicked(with: Repository)
}

struct EmptyStep: Step {
    
}
