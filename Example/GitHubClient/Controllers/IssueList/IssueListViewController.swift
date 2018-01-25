//
//  IssueListViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 18/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reusable
import RxSwift
import UIKit

class IssueListViewController: UIViewController, StoryboardBased {

    @IBOutlet private weak var tableView: UITableView!

    let viewModel = IssueListViewModel()

    private let disposeBag = DisposeBag()

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension IssueListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.issues.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NotificationCell.self)
        let issue = viewModel.issues.value[indexPath.row]
//        cell.subjectLabel.text = notification.subject.title
//        cell.dateLabel.text = notification.updatedAt
//        cell.markButton.isHidden = !notification.unread
//        switch issues.subject.type {
//        case "Issue":
//            cell.typeImageView.image = #imageLiteral(resourceName: "issue-opened")
//        case "PullRequest":
//            cell.typeImageView.image = #imageLiteral(resourceName: "pull-request")
//        case "Release":
//            cell.typeImageView.image = #imageLiteral(resourceName: "tag")
//        default:
//            cell.typeImageView.image = nil
//        }
        return cell
    }
}
