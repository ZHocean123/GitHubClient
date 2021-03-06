//
//  AppDelegate.swift
//  GitHubClient
//
//  Created by ZHocean123 on 10/26/2017.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import GitHubClient
import UIKit
import URLNavigator

let navigator = Navigator()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        Github.clientSecret = "b560271b6af28686bdc92554296a4f88249a7871"

        navigator.register("app://repo") { (_, _, context) in
            let controller = RepositoryDetailViewController.instantiate()
            controller.viewModel.repo = context as? Repository
            return controller
        }
        navigator.register("app://repo/<owner>/<name>") { (_, values, _) in
            let controller = RepositoryDetailViewController.instantiate()
            controller.viewModel.owner = values["owner"] as? String
            controller.viewModel.name = values["name"] as? String
            return controller
        }
        navigator.register("app://user") { (_, _, context) in
            let controller = UserDetailViewController.instantiate()
            controller.viewModel.userVariable.value = context as? User
            return controller
        }
        navigator.register("app://user/<login>") { (_, values, _) in
            let controller = UserDetailViewController.instantiate()
            controller.viewModel.loginName = values["login"] as? String
            return controller
        }
        navigator.register("app://users/<loginName>/repos") { (_, values, _) in
            guard let username = values["loginName"] as? String else { return nil }
            let controller = RepositoryListViewController.instantiate()
            controller.viewModel.sourceType = .user(username: username)
            return controller
        }
        navigator.register("app://repo/<owner>/<name>/issues") { (_, values, _) in
            guard let owner = values["owner"] as? String, let name = values["name"] as? String else {
                return nil
            }
            let controller = IssueListViewController.instantiate()
            controller.viewModel.sourceType = .repo(owner: owner, name: name)
            return controller
        }
        navigator.register("app://repo/<owner>/<repo>/issues/<int:number>") { (_, values, _) in
            guard let owner = values["owner"] as? String,
                let repo = values["repo"] as? String,
                let number = values["number"] as? Int else {
                    return nil
            }
            let controller = IssueDetailViewController.instantiate()
            controller.viewModel.repo = repo
            controller.viewModel.owner = owner
            controller.viewModel.number = number
            return controller
        }

        UITableView.appearance().backgroundColor = UIColor.appBgColor

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
