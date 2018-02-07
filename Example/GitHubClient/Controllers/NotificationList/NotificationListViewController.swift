//
//  NotificationListViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 02/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import CFNotify
import GitHubClient
import RxSwift
import UIKit

class NotificationListViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let disposeBag = DisposeBag()
    private let viewModel = NotificationListViewModel()

    func bindViewModel() {
        viewModel.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            switch state {
            case .loading:
                self?.showProcess()
            case .loaded:
                self?.hideAllHUD()
                self?.tableView.reloadData()
            case .error(let error):
                self?.showError(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(cellType: NotificationCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        bindViewModel()
        viewModel.loadNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func loadNotifications() {
//        Github.shared.notifications(success: { [weak self] (result) in
//            DispatchQueue.global(qos: .utility).async {
//                DispatchQueue.main.async {
//                    self?.notifications = result
//                    self?.tableView.reloadData()
//                }
//            }
//        }) { (error) in
//            log.error(error)
//
//            // config
//            var classicViewConfig = CFNotify.Config()
//            classicViewConfig.initPosition = .top(.center)
//            classicViewConfig.appearPosition = .top
//            classicViewConfig.hideTime = .never
//
//            // view
//            let cyberView = CFNotifyView.cyberWith(title: "Error",
//                                                   body: error.localizedDescription,
//                                                   theme: .fail(.light))
//
//            CFNotify.present(config: classicViewConfig, view: cyberView, tapHandler: nil)
//        }
//    }
}

extension NotificationListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notifications.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NotificationCell.self)
        cell.notification = viewModel.notifications.value[indexPath.row]
        return cell
    }
}
