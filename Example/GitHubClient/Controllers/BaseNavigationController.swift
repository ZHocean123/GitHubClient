//
//  BaseNavigationController.swift
//  GitHubClient_Example
//
//  Created by yang on 05/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//
//    func commonInit() {
//
//    }

    var barAlpha: CGFloat {
        set {
            realBar.alpha = barAlpha
        }
        get {
            return realBar.alpha
        }
    }

    var barColor: UIColor? {
        set {
            realBar.backgroundColor = barColor
        }
        get {
            return realBar.backgroundColor
        }
    }

    class FullscreenPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
        weak var navigationController: BaseNavigationController?

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let navigationController = navigationController else {
                return false
            }
            if navigationController.viewControllers.count <= 1 {
                return false
            }

            if let isTransitioning = navigationController.value(forKey: "_isTransitioning") as? Bool,
                isTransitioning == true {
                return false
            }

            return true
        }
    }

    let fullscreenPopGestureRecognizer = UIPanGestureRecognizer()
    let popGestureRecognizerDelegate = FullscreenPopGestureRecognizerDelegate()

    let realBar = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage.clear, for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage.clear

        realBar.backgroundColor = UIColor.gray
        realBar.frame = navigationBar.bounds
        view.insertSubview(realBar, belowSubview: navigationBar)

        popGestureRecognizerDelegate.navigationController = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        realBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: navigationBar.frame.maxY)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let interactivePopGestureRecognizerView = self.interactivePopGestureRecognizer?.view else {
            super.pushViewController(viewController, animated: animated)
            return
        }

        let gestureRecognizers = interactivePopGestureRecognizerView.gestureRecognizers ?? []

        if !gestureRecognizers.contains(fullscreenPopGestureRecognizer) {
            interactivePopGestureRecognizerView.addGestureRecognizer(fullscreenPopGestureRecognizer)

            let internalTargets = (self.interactivePopGestureRecognizer?.value(forKey: "targets") as? [AnyObject]) ?? []

            if let internalTarget = internalTargets.first?.value(forKey: "target") {
                self.fullscreenPopGestureRecognizer.addTarget(internalTarget,
                                                              action: Selector(("handleNavigationTransition:")))
            }
            self.fullscreenPopGestureRecognizer.delegate = self.popGestureRecognizerDelegate
            self.interactivePopGestureRecognizer?.isEnabled = false
        }

        if !self.viewControllers.contains(viewController) {
            super.pushViewController(viewController, animated: animated)
        }
    }
}
