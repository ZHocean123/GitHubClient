//
//  IssueDetailViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 18/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reusable
import UIKit
import RxSwift

class IssueDetailViewController: UIViewController, StoryboardBased {

    let viewModel = IssueDetailViewModel()

    @IBOutlet weak var tableView: UITableView!

    private let disposeBag = DisposeBag()

    func bindViewModel() {
//        viewModel.loadingState.asObservable().subscribe(onNext: { [weak self] state in
//            switch state {
//            case .loading:
//                self?.showProcess()
//            case .loaded:
//                self?.hideAllHUD()
//                self?.tableview.reloadData()
//            case .error(let error):
//                self?.showError(error.localizedDescription)
//            }
//        }).disposed(by: disposeBag)

        viewModel.comments.asObservable().subscribe(onNext: { [weak self] comments in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(cellType: IssueCommontCell.self)
        viewModel.loadComments()
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

extension IssueDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: IssueCommontCell.self)
        cell.viewModel = viewModel.comments.value[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.value.count
    }
}
