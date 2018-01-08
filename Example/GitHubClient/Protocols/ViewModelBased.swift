//
//  ViewModelBased.swift
//  GitHubClient_Example
//
//  Created by yang on 04/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Reusable

protocol ViewModelBased: class {
    associatedtype ViewModel
    
    var viewModel: ViewModel { get set }
}

extension StoryboardBased where Self: UIViewController & ViewModelBased {
    static func instantiate(with viewModel: ViewModel) -> Self {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension Reusable where Self: UIViewController & ViewModelBased {
    static func instantiate(with viewModel: ViewModel) -> Self {
        let viewController = Self.init()
        viewController.viewModel = viewModel
        return viewController
    }
}
