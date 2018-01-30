//
//  EventsViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 30/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import CFNotify
import GitHubClient
import Kingfisher
import MJRefresh
import Reusable
import RxSwift
import UIKit

class EventListViewController: UIViewController {

    var viewModel = EventListViewModel()

    let disposeBag = DisposeBag()

    @IBOutlet private weak var tableView: UITableView!

    func bindViewModel() {
        viewModel.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            switch state {
            case .loading:
                if self?.viewModel.layoutList.value.count == 0 {
                    self?.showProcess()
                }
            case .loaded:
                self?.hideAllHUD()
                self?.tableView.reloadData()
                self?.tableView.mj_header.endRefreshing()
            case .error(let error):
                self?.showError(error.localizedDescription)
                self?.tableView.mj_header.endRefreshing()
            }
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(cellType: EventCell.self)
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.viewModel.loadEvents()
        })
        bindViewModel()
        viewModel.loadEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

extension EventListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.layoutList.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EventCell.self)
        cell.layout = viewModel.layoutList.value[indexPath.row]
        return cell
    }
}

extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.layoutList.value[indexPath.row].cellHeight
    }
}
